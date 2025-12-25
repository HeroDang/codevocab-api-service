from sqlalchemy.orm import Session
from uuid import UUID
from fastapi import HTTPException, status
from sqlalchemy import func
from typing import List


from app.models.modules import Module
from app.schemas.modules import ModuleCreate, AdminModuleCreate
from app.models.user import User
from app.models.words import Word
from app.models.module_word import ModuleWord
from app.schemas.modules import ModuleUpdate
from app.models.module_delete import ModuleDelete
import datetime

class ModuleService:

    @staticmethod
    def get_all_for_admin(db: Session, name: str | None = None):
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

        query = (
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
            .filter(ModuleDelete.module_id.is_(None), Module.module_type == "system")
        )

        if name:
            query = query.filter(Module.name.ilike(f"%{name}%"))

        results = query.all()

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

    @staticmethod
    def create_for_admin(db: Session, data: ModuleCreate):
        # existing_module = db.query(Module).first()
        # if existing_module:
        #     raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="A module with this name already exists")
        
        new_module = Module(**data.model_dump())
        db.add(new_module)
        db.commit()
        db.refresh(new_module)
        return new_module

    @staticmethod
    def create_module_with_words_for_admin(
        db: Session,
        data: AdminModuleCreate,
        admin_id: UUID
    ):
        """
        Create a SYSTEM module for admin and attach words to it.
        
        - If parent_id is None -> create ROOT module
        - Module type is always 'system'
        """

        module_data = data.model_dump(exclude={"word_ids"})

        # ✅ Ensure default parent_id = None (root module)
        # module_data["parent_id"] = "1edb92b8-0a10-4704-b304-8cbb0fbaf8be"

        new_module = Module(
            **module_data,
            owner_id=admin_id,
            module_type="system"
        )

        db.add(new_module)
        db.flush()  # get new_module.id before insert module_words

        # 🔗 Attach words
        for word_id in data.word_ids:
            word = db.query(Word).filter(Word.id == word_id).first()
            if not word:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail=f"Word with id {word_id} not found"
                )

            db.add(
                ModuleWord(
                    module_id=new_module.id,
                    word_id=word_id
                )
            )

        db.commit()
        db.refresh(new_module)
        return new_module


    @staticmethod
    def update_for_admin(db: Session, module_id: UUID, data: ModuleUpdate):
        module = db.query(Module).outerjoin(ModuleDelete, Module.id == ModuleDelete.module_id).filter(Module.id == module_id, ModuleDelete.module_id.is_(None)).first()
        if not module:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found or has been deleted")

        # existing_module = db.query(Module).filter(Module.id != module_id).first()
        # if existing_module:
        #     raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="A module with this name already exists")

        for key, value in data.model_dump(exclude_unset=True).items():
            setattr(module, key, value)

        db.commit()
        db.refresh(module)
        return module

    @staticmethod
    def remove_words_from_module_for_admin(db: Session, module_id: UUID, word_id: UUID):
        # 1. Check if module exists
        module = db.query(Module).filter(Module.id == module_id).first()
        if not module:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found")

        # 2. Delete the associations
        db.query(ModuleWord).filter(
            ModuleWord.module_id == module_id,
            ModuleWord.word_id == word_id
        ).delete(synchronize_session=False)

        db.commit()

        return {"message": "Words removed from module successfully"}

    @staticmethod
    def update_module_words_for_admin(db: Session, module_id: UUID, word_ids: List[UUID]):
        # 1. Check if module exists
        module = db.query(Module).filter(Module.id == module_id).first()
        if not module:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found")

        # 2. Delete existing associations
        db.query(ModuleWord).filter(ModuleWord.module_id == module_id).delete(synchronize_session=False)

        # 3. Add new associations
        for word_id in word_ids:
            word = db.query(Word).filter(Word.id == word_id).first()
            if not word:
                # maybe collect all missing words and return one error
                raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Word with id {word_id} not found")
            module_word = ModuleWord(module_id=module_id, word_id=word_id)
            db.add(module_word)

        db.commit()
        return ModuleService.get_words_by_module(db, module_id)

    @staticmethod
    def add_words_to_module(db: Session, module_id: UUID, word_ids: List[UUID]):
        # 1. Check if module exists
        module = db.query(Module).filter(Module.id == module_id).first()
        if not module:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found")

        # 2. Add new associations, avoiding duplicates
        added_count = 0
        for word_id in word_ids:
            # Check if word exists
            word = db.query(Word).filter(Word.id == word_id).first()
            if not word:
                # Or collect all not found and raise one error
                raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Word with id {word_id} not found")

            # Check if association already exists
            existing_association = db.query(ModuleWord).filter_by(module_id=module_id, word_id=word_id).first()
            if not existing_association:
                module_word = ModuleWord(module_id=module_id, word_id=word_id)
                db.add(module_word)
                added_count += 1
        
        db.commit()

        return {"message": f"Added {added_count} words to module successfully."}

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

        # a. subquery to count words in modules
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

        # 2️⃣ Lấy module con and their word counts
        children_results = (
            db.query(
                Module,
                word_count_subquery.c.word_count.label("count_word")
            )
            .outerjoin(ModuleDelete, Module.id == ModuleDelete.module_id)
            .outerjoin(word_count_subquery, Module.id == word_count_subquery.c.module_id)
            .filter(Module.parent_id == module.id, ModuleDelete.module_id.is_(None))
            .order_by(Module.created_at.asc())
            .all()
        )
        
        children_with_counts = []
        total_word_count = 0
        for child_module, count in children_results:
            child_module.count_word = count or 0
            children_with_counts.append(child_module)
            total_word_count += (count or 0)

        # 3️⃣ Gắn children và total word count
        module.children = children_with_counts
        module.count_word = total_word_count

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
