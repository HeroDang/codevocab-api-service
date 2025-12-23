from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from uuid import UUID
from typing import List, Optional

from app.db import get_db
from app.dependencies.authz import require_admin
from app.models.modules import Module
from app.schemas.modules import ModuleCreate, ModuleOut, ModuleUpdate
from app.schemas.words import WordOut
from app.services.module_service import ModuleService

router = APIRouter(
    prefix="/admin/modules",
    tags=["admin-modules"],
    dependencies=[Depends(require_admin)],
)


# ==========================================================
# GET ALL — Admin xem tất cả module hệ thống
# ==========================================================
@router.get("/", response_model=list[ModuleOut])
def get_all_modules(
    db: Session = Depends(get_db),
    owner_id: Optional[UUID] = None,
    parent_id: Optional[UUID] = None,
    name: Optional[str] = None,
    module_type: Optional[str] = None,
    is_public: Optional[bool] = None,
):
    """
    Retrieve all modules with optional filters. (Admin only)
    """
    query = db.query(Module)

    if owner_id:
        query = query.filter(Module.owner_id == owner_id)
    if parent_id:
        query = query.filter(Module.parent_id == parent_id)
    if name:
        query = query.filter(Module.name.ilike(f"%{name}%"))
    if module_type:
        query = query.filter(Module.module_type == module_type)
    if is_public is not None:
        query = query.filter(Module.is_public == is_public)
        
    return query.all()


# ==========================================================
# GET WORDS BY MODULE — Admin xem tất cả từ trong module
# ==========================================================
@router.get("/{module_id}/words", response_model=List[WordOut])
def get_words_by_module_admin(
    module_id: UUID,
    db: Session = Depends(get_db)
):
    words = ModuleService.get_words_by_module(db, module_id)
    if words is None:
        raise HTTPException(status_code=404, detail="Module not found")
    return words


# ==========================================================
# CREATE — Admin tạo module hệ thống
# ==========================================================
@router.post("/", response_model=ModuleOut, status_code=201)
def create_module(data: ModuleCreate, db: Session = Depends(get_db)):
    new_module = Module(**data.model_dump())
    db.add(new_module)
    db.commit()
    db.refresh(new_module)
    return new_module


# ==========================================================
# UPDATE — Admin sửa module hệ thống
# ==========================================================
@router.put("/{module_id}", response_model=ModuleOut)
def update_module(
    module_id: UUID,
    data: ModuleUpdate,
    db: Session = Depends(get_db),
):
    module = db.query(Module).filter(Module.id == module_id).first()
    if not module:
        raise HTTPException(status_code=404, detail="Module not found")

    for key, value in data.model_dump(exclude_unset=True).items():
        setattr(module, key, value)

    db.commit()
    db.refresh(module)
    return module


# ==========================================================
# DELETE — Admin xoá module hệ thống
# ==========================================================
@router.delete("/{module_id}", status_code=204)
def delete_module(module_id: UUID, db: Session = Depends(get_db)):
    module = db.query(Module).filter(Module.id == module_id).first()
    if not module:
        raise HTTPException(status_code=404, detail="Module not found")

    db.delete(module)
    db.commit()
    return
