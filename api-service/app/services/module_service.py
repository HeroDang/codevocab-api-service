from sqlalchemy.orm import Session
from app.models.modules import Module
from app.schemas.modules import ModuleCreate

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
