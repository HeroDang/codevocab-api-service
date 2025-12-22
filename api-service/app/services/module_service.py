from sqlalchemy.orm import Session
from uuid import UUID
from fastapi import HTTPException, status

from app.models.modules import Module
from app.schemas.modules import ModuleCreate
from app.models.words import Word
from app.models.module_word import ModuleWord
from app.schemas.modules import ModuleUpdate

class ModuleService:

    @staticmethod
    def get_all(db: Session):
        return db.query(Module).all()

    @staticmethod
    def create(db: Session, data: ModuleCreate):
        new_module = Module(**data.model_dump())
        db.add(new_module)

    @staticmethod
    # def update_module(db: Session, module_id: UUID, data: ModuleUpdate, user_id: UUID):
    def update_module(db: Session, module_id: UUID, data: ModuleUpdate):
        module = db.query(Module).filter(Module.id == module_id).first()
        
        if not module:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found")
            
        # if module.owner_id != user_id:
        #     raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not authorized to update this module")
            
        if data.name is not None:
            module.name = data.name
        if data.description is not None:
            module.description = data.description
        if data.is_public is not None:
            module.is_public = data.is_public
            
        db.commit()
        db.refresh(module)
        return module

    @staticmethod
    def get_user_root_modules(db: Session):
        return (
            db.query(Module)
            .filter(
                Module.parent_id.is_(None)
            )
            .order_by(Module.created_at.desc())
            .all()
        )

    @staticmethod
    def get_module_detail(db: Session, module_id: UUID) -> Module | None:
        # 1️⃣ Lấy module cha
        module = (
            db.query(Module)
            .filter(Module.id == module_id)
            .first()
        )

        if not module:
            return None

        # 2️⃣ Lấy module con
        children = (
            db.query(Module)
            .filter(Module.parent_id == module.id)
            .order_by(Module.created_at.asc())
            .all()
        )

        # 3️⃣ Gắn children
        module.children = children

        db.refresh(module)
        return module

    def get_words_by_module(
        db: Session,
        module_id: UUID,
    ):
        # 1️⃣ Check module tồn tại
        module = (
            db.query(Module)
            .filter(Module.id == module_id)
            .first()
        )
        if not module:
            return None

        # 2️⃣ Lấy danh sách words trong module
        words = (
            db.query(Word)
            .join(ModuleWord, ModuleWord.word_id == Word.id)
            .filter(ModuleWord.module_id == module_id)
            .order_by(Word.text_en.asc())
            .all()
        )

        return words

    @staticmethod
    def get_modules_by_user(
        db: Session,
        user_id: UUID,
        module_type: str | None = None
    ):
        query = (
            db.query(Module)
            .filter(
                Module.owner_id == user_id
            )
        )

        if module_type:
            query = query.filter(Module.module_type == module_type)

        return query.order_by(Module.created_at.desc()).all()