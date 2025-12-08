from fastapi import Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.db import get_db
from app.routers.auth import get_current_user
from app.models.group_member import GroupMember
from app.models.group import Group

def require_group_member(
    group_id: str,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    member = db.query(GroupMember).filter(
        GroupMember.group_id == group_id,
        GroupMember.user_id == current_user.id
    ).first()

    if not member:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You are not a member of this group"
        )
    return current_user

def require_group_owner(
    group_id: str,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    group = db.query(Group).filter(Group.id == group_id).first()

    if not group:
        raise HTTPException(
            status_code=404,
            detail="Group not found"
        )

    if group.owner_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only group owner can perform this action"
        )
    return current_user
