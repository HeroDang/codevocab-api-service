from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.orm import Session
from uuid import UUID
from typing import List, Optional

from app.db import get_db
from app.db_sql import sql
from app.schemas.modules import ModuleOut, ModuleUpdate
from app.services.module_service import ModuleService
from app.dependencies.authz import require_user
from app.schemas.modules import ModuleCreate, ModuleOut, ModuleDetailOut
from app.schemas.auth import UserInDB
from app.schemas.words import WordOut
from app.routers.auth import get_current_user


router = APIRouter(
    prefix="/modules",
    tags=["Modules"],
    dependencies=[Depends(require_user)],   # BẢO VỆ TOÀN ROUTER
)

@router.get("/sql")
def get_modules(db: Session = Depends(get_db)):
    result = db.execute(sql("SELECT id, name, parent_id FROM modules;"))
    data = [{"id": str(r[0]), "name": r[1], "parent_id": str(r[2]) if r[2] else None} for r in result]
    return {"modules": data}

@router.get("/", response_model=list[ModuleOut])
def list_modules(db: Session = Depends(get_db)):
    return ModuleService.get_all(db)

@router.post("/", response_model=ModuleOut)
def create_module(data: ModuleCreate, db: Session = Depends(get_db)):
    return ModuleService.create(db, data)

@router.get("", response_model=List[ModuleOut])
def get_modules(
    db: Session = Depends(get_db)
):
    return ModuleService.get_user_root_modules(
        db=db
    )

@router.get("/user_modules", response_model=list[ModuleOut])
def get_user_modules(
    current_user_id: UUID = Query(..., description="User ID for testing only"),
    module_type: Optional[str] = Query(
        default=None,
        description="Filter by module type (personal | system)"
    ),
    db: Session = Depends(get_db),
):
    return ModuleService.get_modules_by_user(
        db=db,
        user_id=current_user_id,
        module_type=module_type
    )

@router.get("/{module_id}", response_model=ModuleDetailOut)
def get_module_detail(
    module_id: UUID,
    db: Session = Depends(get_db),
):
    module = ModuleService.get_module_detail(db, module_id)
    if not module:
        raise HTTPException(status_code=404, detail="Module not found")
    return module

@router.put("/{module_id}", response_model=ModuleOut)
def update_module(
    module_id: UUID,
    module_data: ModuleUpdate,
    db: Session = Depends(get_db),
    # current_user = Depends(require_user)
):
    # return ModuleService.update_module(db, module_id, module_data, current_user.id)
    return ModuleService.update_module(db, module_id, module_data)

@router.get(
    "/{module_id}/words",
    response_model=List[WordOut]
)
def get_module_words(
    module_id: UUID,
    db: Session = Depends(get_db),
):
    words = ModuleService.get_words_by_module(db, module_id)

    if words is None:
        raise HTTPException(status_code=404, detail="Module not found")

    return words
