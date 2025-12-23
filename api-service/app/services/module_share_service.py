from sqlalchemy.orm import Session
from uuid import UUID
from fastapi import HTTPException, status
from sqlalchemy import func

from app.models.module_share import ModuleShare
from app.models.modules import Module
from app.models.user import User
from app.models.module_word import ModuleWord
from app.schemas.module_share import ModuleShareCreate

class ModuleShareService:
    @staticmethod
    def create_share(db: Session, share_data: ModuleShareCreate, from_user_id: UUID):
        # Check if the module exists
        module_to_share = db.query(Module).filter(Module.id == share_data.module_id).first()
        if not module_to_share:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found")

        # Check if the user sharing is the owner of the module
        if module_to_share.owner_id != from_user_id:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="You are not the owner of this module")
        
        # Check if the share already exists
        existing_share = db.query(ModuleShare).filter_by(
            module_id=share_data.module_id,
            to_user=share_data.to_user
        ).first()

        if existing_share:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Module already shared with this user")

        new_share = ModuleShare(
            module_id=share_data.module_id,
            from_user=from_user_id,
            to_user=share_data.to_user,
            status='pending'  # As requested, default status
        )
        db.add(new_share)
        db.commit()
        db.refresh(new_share)
        return new_share

    @staticmethod
    def get_shared_modules_for_user(db: Session, user_id: UUID):
        word_count_subquery = (
            db.query(
                ModuleWord.module_id,
                func.count(ModuleWord.word_id).label("word_count"),
            )
            .group_by(ModuleWord.module_id)
            .subquery()
        )

        results = (
            db.query(
                Module,
                User.name.label("owner_name"),
                word_count_subquery.c.word_count.label("count_word"),
                ModuleShare.status,
            )
            .join(ModuleShare, ModuleShare.module_id == Module.id)
            .join(User, User.id == Module.owner_id)
            .outerjoin(
                word_count_subquery, word_count_subquery.c.module_id == Module.id
            )
            .filter(ModuleShare.to_user == user_id)
            .all()
        )

        response_data = []
        for module, owner_name, count_word, status in results:
            module_data = {
                "id": module.id,
                "name": module.name,
                "description": module.description,
                "module_type": module.module_type,
                "is_public": module.is_public,
                "created_at": module.created_at,
                "owner_name": owner_name,
                "count_word": count_word or 0,
                "status": status,
            }
            response_data.append(module_data)

        return response_data

    @staticmethod
    def accept_share(db: Session, module_id: UUID, user_id: UUID):
        share_request = db.query(ModuleShare).filter(
            ModuleShare.module_id == module_id,
            ModuleShare.to_user == user_id
        ).first()

        if not share_request:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Share request not found for this module and user")

        if share_request.status != 'pending':
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Share request is not in a pending state")

        share_request.status = 'accepted'
        db.commit()
        db.refresh(share_request)
        return share_request
