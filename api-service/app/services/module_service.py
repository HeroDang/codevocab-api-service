from sqlalchemy.orm import Session
from uuid import UUID
from app.models.modules import Module
from app.schemas.modules import ModuleCreate
from app.models.words import Word
from app.models.module_word import ModuleWord

class ModuleService:

    @staticmethod
    def get_all(db: Session):
        return db.query(Module).all()

    @staticmethod
    def create(db: Session, data: ModuleCreate):
        new_module = Module(**data.model_dump())
        db.add(new_module)
        db.commit()
        db.refresh(new_module)
        return new_module

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