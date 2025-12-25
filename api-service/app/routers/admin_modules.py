from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from uuid import UUID
from typing import List, Optional

from app.db import get_db
from app.dependencies.authz import get_current_user, require_admin
from app.models.user import User
from app.schemas.modules import ModuleCreate, ModuleOut, ModuleUpdate, MarketModuleOut
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
@router.get("/", response_model=list[MarketModuleOut])
def get_all_modules(
    db: Session = Depends(get_db),
    name: Optional[str] = None,
):
    """
    Retrieve all modules with optional filters. (Admin only)
    """
    return ModuleService.get_all_for_admin(db, name=name)


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
    return ModuleService.create_for_admin(db, data)


# ==========================================================
# UPDATE — Admin sửa module hệ thống
# ==========================================================
@router.put("/{module_id}", response_model=ModuleOut)
def update_module(
    module_id: UUID,
    data: ModuleUpdate,
    db: Session = Depends(get_db),
):
    return ModuleService.update_for_admin(db, module_id, data)


# ==========================================================
# DELETE — Admin xoá module hệ thống
# ==========================================================
@router.delete("/{module_id}", status_code=200)
def delete_module(
    module_id: UUID, 
    db: Session = Depends(get_db), 
    current_user: User = Depends(get_current_user)
):
    return ModuleService.delete(db, module_id, current_user.id)

# ==========================================================
# RESTORE — Admin khôi phục module hệ thống
# ==========================================================
@router.post("/{module_id}/restore", response_model=ModuleOut)
def restore_module(
    module_id: UUID,
    db: Session = Depends(get_db),
):
    return ModuleService.restore_for_admin(db, module_id)

