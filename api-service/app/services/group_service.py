from sqlalchemy.orm import Session
from typing import List
from uuid import UUID

from app.models.group import Group
from app.models.group_member import GroupMember
from app.models.user import User
from app.schemas.group import GroupCreate


class GroupService:
    @staticmethod
    def create(db: Session, owner_id: UUID, data: GroupCreate) -> Group:
        group = Group(name=data.name, owner_id=owner_id)
        db.add(group)
        db.commit()
        db.refresh(group)

        # add owner as member
        member = GroupMember(group_id=group.id, user_id=owner_id, user_email="")
        # try to fill email if user exists
        user = db.query(User).filter(User.id == owner_id).first()
        if user:
            member.user_email = user.email

        db.add(member)
        db.commit()
        return group

    @staticmethod
    def get(db: Session, group_id: UUID) -> Group | None:
        return db.query(Group).filter(Group.id == group_id).first()

    @staticmethod
    def rename(db: Session, group_id: UUID, new_name: str) -> Group | None:
        group = db.query(Group).filter(Group.id == group_id).first()
        if not group:
            return None
        group.name = new_name
        db.commit()
        db.refresh(group)
        return group

    @staticmethod
    def add_member_by_email(db: Session, group_id: UUID, user_email: str) -> GroupMember:
        # ensure group exists
        group = db.query(Group).filter(Group.id == group_id).first()
        if not group:
            raise ValueError("Group not found")

        user = db.query(User).filter(User.email == user_email).first()
        if not user:
            raise ValueError("User not found")

        exists = db.query(GroupMember).filter(
            GroupMember.group_id == group_id,
            GroupMember.user_id == user.id
        ).first()
        if exists:
            raise ValueError("User already in group")

        member = GroupMember(group_id=group_id, user_id=user.id, user_email=user.email)
        db.add(member)
        db.commit()
        db.refresh(member)
        return member

    @staticmethod
    def remove_member(db: Session, group_id: UUID, user_id: UUID) -> bool:
        member = db.query(GroupMember).filter(
            GroupMember.group_id == group_id,
            GroupMember.user_id == user_id
        ).first()
        if not member:
            return False
        db.delete(member)
        db.commit()
        return True

    @staticmethod
    def list_members(db: Session, group_id: UUID) -> List[GroupMember]:
        return db.query(GroupMember).filter(GroupMember.group_id == group_id).all()
