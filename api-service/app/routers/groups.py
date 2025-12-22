from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from uuid import UUID

from app.db import get_db
from app.routers.auth import get_current_user
from app.dependencies.group_authz import require_group_owner, require_group_member

from app.models.group import Group
from app.models.group_member import GroupMember
from app.models.user import User

from app.schemas.group import GroupCreate, GroupOut, GroupMemberOut

router = APIRouter(
    prefix="/groups",
    tags=["groups"]
)


# ==========================================================
# Create group (User)
# ==========================================================
@router.post("/", response_model=GroupOut)
def create_group(
    data: GroupCreate,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    group = Group(
        name=data.name,
        owner_id=current_user.id
    )
    db.add(group)
    db.commit()
    db.refresh(group)

    # Add owner as member
    member = GroupMember(group_id=group.id, user_id=current_user.id)
    db.add(member)
    db.commit()

    return group


# ==========================================================
# Get group detail (member only)
# ==========================================================
@router.get("/{group_id}", response_model=GroupOut)
def get_group_details(
    group_id: UUID,
    db: Session = Depends(get_db),
    current_user = Depends(require_group_member)
):
    group = db.query(Group).filter(Group.id == group_id).first()
    if not group:
        raise HTTPException(404, "Group not found")
    return group


# ==========================================================
# Rename group (OWNER)
# ==========================================================
@router.patch("/{group_id}/rename", response_model=GroupOut)
def rename_group(
    group_id: UUID,
    new_name: str,
    db: Session = Depends(get_db),
    current_user = Depends(require_group_owner)
):
    group = db.query(Group).filter(Group.id == group_id).first()
    group.name = new_name
    db.commit()
    db.refresh(group)
    return group


# ==========================================================
# Add member (OWNER)
# ==========================================================
@router.post("/{group_id}/members/{user_email}", response_model=GroupMemberOut)
def add_member(
    group_id: UUID,
    user_email: str,
    db: Session = Depends(get_db),
    current_user = Depends(require_group_owner)
):
    # Ensure group exists
    group = db.query(Group).filter(Group.id == group_id).first()
    if not group:
        raise HTTPException(404, "Group not found")

    # Find user by email
    user = db.query(User).filter(User.email == user_email).first()
    if not user:
        raise HTTPException(404, "User not found")

    # Check existing membership
    exists = db.query(GroupMember).filter(
        GroupMember.group_id == group_id,
        GroupMember.user_id == user.id
    ).first()
    if exists:
        raise HTTPException(400, "User already in group")

    # Create member, include user_email (model requires it)
    member = GroupMember(group_id=group_id, user_id=user.id, user_email=user.email)
    db.add(member)
    db.commit()
    db.refresh(member)
    return member


# ==========================================================
# Remove member (OWNER)
# ==========================================================
@router.delete("/{group_id}/members/{user_id}")
def remove_member(
    group_id: UUID,
    user_id: UUID,
    db: Session = Depends(get_db),
    current_user = Depends(require_group_owner)
):
    member = db.query(GroupMember).filter(
        GroupMember.group_id == group_id,
        GroupMember.user_id == user_id
    ).first()

    if not member:
        raise HTTPException(404, "Member not found")

    db.delete(member)
    db.commit()
    return {"message": "Member removed"}


# ==========================================================
# Delete group (OWNER)
# ==========================================================
@router.delete("/{group_id}")
def delete_group(
    group_id: UUID,
    db: Session = Depends(get_db),
    current_user = Depends(require_group_owner)
):
    db.query(GroupMember).filter(GroupMember.group_id == group_id).delete()
    db.query(Group).filter(Group.id == group_id).delete()
    db.commit()
    return {"message": "Group deleted"}


# ==========================================================
# List members (OWNER + MEMBER)
# ==========================================================
@router.get("/{group_id}/members", response_model=list[GroupMemberOut])
def list_members(
    group_id: UUID,
    db: Session = Depends(get_db),
    current_user = Depends(require_group_member)
):
    members = db.query(GroupMember).filter(GroupMember.group_id == group_id).all()
    return members
