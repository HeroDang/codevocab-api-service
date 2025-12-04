from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.db import get_db
from app.db_sql import sql
from app.schemas.modules import ModuleCreate, ModuleResponse
from app.services.module_service import ModuleService

router = APIRouter()

@router.get("/sql")
def get_modules(db: Session = Depends(get_db)):
    result = db.execute(sql("SELECT id, name, parent_id FROM modules;"))
    data = [{"id": str(r[0]), "name": r[1], "parent_id": str(r[2]) if r[2] else None} for r in result]
    return {"modules": data}

@router.get("/", response_model=list[ModuleResponse])
def list_modules(db: Session = Depends(get_db)):
    return ModuleService.get_all(db)

@router.post("/", response_model=ModuleResponse)
def create_module(data: ModuleCreate, db: Session = Depends(get_db)):
    return ModuleService.create(db, data)
