from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.db import get_db
from app.dependencies.authz import require_admin
from app.models.modules import Module            
from app.schemas.modules import ModuleCreate, ModuleOut  

router = APIRouter(
    prefix="/admin/modules",
    tags=["admin-modules"],
    dependencies=[Depends(require_admin)],
)


# ==========================================================
# GET ALL — Admin xem tất cả module hệ thống
# ==========================================================
@router.get("/", response_model=list[ModuleOut])
def get_all_modules(db: Session = Depends(get_db)):
    return db.query(Module).all()


# ==========================================================
# CREATE — Admin tạo module hệ thống
# ==========================================================
@router.post("/", response_model=ModuleOut, status_code=201)
def create_module(data: ModuleCreate, db: Session = Depends(get_db)):
    new_module = Module(
        title=data.title,
        description=data.description,
        is_public=data.is_public,
    )
    db.add(new_module)
    db.commit()
    db.refresh(new_module)
    return new_module


# ==========================================================
# UPDATE — Admin sửa module hệ thống
# ==========================================================
@router.put("/{module_id}", response_model=ModuleOut)
def update_module(
    module_id: str,
    data: ModuleCreate,
    db: Session = Depends(get_db),
):
    module = db.query(Module).filter(Module.id == module_id).first()
    if not module:
        raise HTTPException(status_code=404, detail="Module not found")

    module.title = data.title
    module.description = data.description
    module.is_public = data.is_public

    db.commit()
    db.refresh(module)
    return module


# ==========================================================
# DELETE — Admin xoá module hệ thống
# ==========================================================
@router.delete("/{module_id}", status_code=204)
def delete_module(module_id: str, db: Session = Depends(get_db)):
    module = db.query(Module).filter(Module.id == module_id).first()
    if not module:
        raise HTTPException(status_code=404, detail="Module not found")

    db.delete(module)
    db.commit()
    return
