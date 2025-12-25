from sqlalchemy.orm import Session
from uuid import UUID
from fastapi import HTTPException, status
from sqlalchemy import func

from app.models.modules import Module
from app.schemas.modules import ModuleCreate
from app.models.user import User
from app.models.words import Word
from app.models.module_word import ModuleWord
from app.schemas.modules import ModuleUpdate
from app.models.module_delete import ModuleDelete
import datetime

class ModuleService:

    @staticmethod
    def get_all_for_admin(db: Session, name: str | None = None):
        query = db.query(Module).outerjoin(ModuleDelete, Module.id == ModuleDelete.module_id)
        
        if name:
            query = query.filter(Module.name.ilike(f"%{name}%"))
        
        deleted_modules = query.filter(ModuleDelete.module_id != None).all()
        non_deleted_modules = query.filter(ModuleDelete.module_id == None).all()
        
        return non_deleted_modules + deleted_modules

    @staticmethod
    def create_for_admin(db: Session, data: ModuleCreate):
        existing_module = db.query(Module).filter(Module.name == data.name).first()
        if existing_module:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="A module with this name already exists")
        
        new_module = Module(**data.model_dump())
        db.add(new_module)
        db.commit()
        db.refresh(new_module)
        return new_module

    @staticmethod
    def update_for_admin(db: Session, module_id: UUID, data: ModuleUpdate):
        module = db.query(Module).outerjoin(ModuleDelete, Module.id == ModuleDelete.module_id).filter(Module.id == module_id, ModuleDelete.module_id.is_(None)).first()
        if not module:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found or has been deleted")

        existing_module = db.query(Module).filter(Module.name == data.name, Module.id != module_id).first()
        if existing_module:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="A module with this name already exists")

        for key, value in data.model_dump(exclude_unset=True).items():
            setattr(module, key, value)

        db.commit()
        db.refresh(module)
        return module

    @staticmethod
    def restore_for_admin(db: Session, module_id: UUID):
        module = db.query(Module).filter(Module.id == module_id).first()
        if not module:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found")

        deleted_entry = db.query(ModuleDelete).filter(ModuleDelete.module_id == module_id).first()
        if not deleted_entry:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Module is not deleted")

        db.delete(deleted_entry)
        db.commit()

        return module
    
    @staticmethod
    def get_all(db: Session):
        return db.query(Module).outerjoin(ModuleDelete, Module.id == ModuleDelete.module_id).filter(ModuleDelete.module_id.is_(None)).all()

    @staticmethod
    def create(db: Session, data: ModuleCreate):
        new_module = Module(**data.model_dump())
        db.add(new_module)
        db.commit()
        db.refresh(new_module)
        return new_module

    @staticmethod
    # def update_module(db: Session, module_id: UUID, data: ModuleUpdate, user_id: UUID):
    def update_module(db: Session, module_id: UUID, data: ModuleUpdate):
        module = db.query(Module).outerjoin(ModuleDelete, Module.id == ModuleDelete.module_id).filter(Module.id == module_id, ModuleDelete.module_id.is_(None)).first()
        
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
    def publish_module(db: Session, module_id: UUID, user_id: UUID):
        module = db.query(Module).outerjoin(ModuleDelete, Module.id == ModuleDelete.module_id).filter(Module.id == module_id, ModuleDelete.module_id.is_(None)).first()
        
        if not module:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found")
            
        if module.owner_id != user_id:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not authorized to publish this module")
            
        module.is_public = True
            
        db.commit()
        db.refresh(module)
        return module

    @staticmethod
    def delete(db: Session, module_id: UUID, user_id: UUID):
        module = db.query(Module).filter(Module.id == module_id).first()
        
        if not module:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found")
            
        if module.owner_id != user_id:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not authorized to delete this module")
            
        existing_delete = db.query(ModuleDelete).filter(ModuleDelete.module_id == module_id).first()
        if existing_delete:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Module already deleted")
            
        module.deleted_at = datetime.datetime.utcnow()
        
        new_module_delete = ModuleDelete(module_id=module_id, user_id=user_id)
        db.add(new_module_delete)
        
        db.commit()
        return {"message": "Module deleted successfully"}

    @staticmethod
    def get_user_root_modules(db: Session):
        return (
            db.query(Module)
            .outerjoin(ModuleDelete, Module.id == ModuleDelete.module_id)
            .filter(
                Module.parent_id.is_(None),
                Module.module_type == "system",
                ModuleDelete.module_id.is_(None)
            )
            .order_by(Module.created_at.desc())
            .all()
        )

    @staticmethod
    def get_module_detail(db: Session, module_id: UUID) -> Module | None:
        # 1️⃣ Lấy module cha
        module = (
            db.query(Module)
            .outerjoin(ModuleDelete, Module.id == ModuleDelete.module_id)
            .filter(Module.id == module_id, ModuleDelete.module_id.is_(None))
            .first()
        )

        if not module:
            return None

        # 2️⃣ Lấy module con
        children = (
            db.query(Module)
            .outerjoin(ModuleDelete, Module.id == ModuleDelete.module_id)
            .filter(Module.parent_id == module.id, ModuleDelete.module_id.is_(None))
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
        from app.models.word_delete import WordDelete
        # 1️⃣ Check module tồn tại
        module = (
            db.query(Module)
            .outerjoin(ModuleDelete, Module.id == ModuleDelete.module_id)
            .filter(Module.id == module_id, ModuleDelete.module_id.is_(None))
            .first()
        )
        if not module:
            return None

        # 2️⃣ Lấy danh sách words trong module
        words = (
            db.query(Word)
            .join(ModuleWord, ModuleWord.word_id == Word.id)
            .outerjoin(WordDelete, Word.id == WordDelete.word_id)
            .filter(ModuleWord.module_id == module_id)
            .filter(WordDelete.word_id.is_(None))
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
            .outerjoin(ModuleDelete, Module.id == ModuleDelete.module_id)
            .filter(
                Module.owner_id == user_id,
                ModuleDelete.module_id.is_(None)
            )
        )

        if module_type:
            query = query.filter(Module.module_type == module_type)

        return query.order_by(Module.created_at.desc()).all()

    @staticmethod
    def get_public_modules(db: Session, user_id: UUID):
        from app.models.word_delete import WordDelete
        word_count_subquery = (
            db.query(
                ModuleWord.module_id,
                func.count(ModuleWord.word_id).label("word_count"),
            )
            .join(Word, Word.id == ModuleWord.word_id)
            .outerjoin(WordDelete, Word.id == WordDelete.word_id)
            .filter(WordDelete.word_id.is_(None))
            .group_by(ModuleWord.module_id)
            .subquery()
        )

        results = (
            db.query(
                Module,
                User.name.label("owner_name"),
                word_count_subquery.c.word_count.label("count_word"),
            )
            .join(User, User.id == Module.owner_id)
            .join(
                word_count_subquery, word_count_subquery.c.module_id == Module.id
            )
            .outerjoin(ModuleDelete, Module.id == ModuleDelete.module_id)
            .filter(Module.is_public == True, Module.owner_id != user_id, ModuleDelete.module_id.is_(None))
            .all()
        )

        response_data = []
        for module, owner_name, count_word in results:
            module_data = {
                "id": module.id,
                "name": module.name,
                "description": module.description,
                "module_type": module.module_type,
                "is_public": module.is_public,
                "created_at": module.created_at,
                "owner_name": owner_name,
                "count_word": count_word,
            }
            response_data.append(module_data)

        return response_data

    @staticmethod
    def get_my_modules(db: Session, user_id: UUID):
        from app.models.word_delete import WordDelete
        word_count_subquery = (
            db.query(
                ModuleWord.module_id,
                func.count(ModuleWord.word_id).label("word_count"),
            )
            .join(Word, Word.id == ModuleWord.word_id)
            .outerjoin(WordDelete, Word.id == WordDelete.word_id)
            .filter(WordDelete.word_id.is_(None))
            .group_by(ModuleWord.module_id)
            .subquery()
        )

        results = (
            db.query(
                Module,
                User.name.label("owner_name"),
                word_count_subquery.c.word_count.label("count_word"),
            )
            .join(User, User.id == Module.owner_id)
            .join(
                word_count_subquery, word_count_subquery.c.module_id == Module.id
            )
            .outerjoin(ModuleDelete, Module.id == ModuleDelete.module_id)
            .filter(Module.owner_id == user_id, Module.module_type == "personal", ModuleDelete.module_id.is_(None))
            .all()
        )

        response_data = []
        for module, owner_name, count_word in results:
            module_data = {
                "id": module.id,
                "name": module.name,
                "description": module.description,
                "module_type": module.module_type,
                "is_public": module.is_public,
                "created_at": module.created_at,
                "owner_name": owner_name,
                "count_word": count_word or 0,
            }
            response_data.append(module_data)

        return response_data
