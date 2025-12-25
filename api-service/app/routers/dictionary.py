from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from uuid import UUID
from typing import List

from app.db import get_db
from app.services.module_service import ModuleService
from app.dependencies.authz import require_user
from app.schemas.modules import MyModuleOut, ModuleOut
from app.schemas.auth import UserInDB
from app.routers.auth import get_current_user
from app.services.module_share_service import ModuleShareService
from app.schemas.module_share import ModuleShareCreate, ModuleShareOut, SharedModuleOut


router = APIRouter(
    prefix="/dictionary",
    tags=["Dictionary"],
    dependencies=[Depends(require_user)],
)

@router.get("/my-module", response_model=List[MyModuleOut])
def get_my_modules(
    db: Session = Depends(get_db),
    current_user: UserInDB = Depends(get_current_user),
):
    """
    Retrieve modules for the current user with module_type 'personal'.
    """
    modules = ModuleService.get_my_modules(db, user_id=current_user.id)
    return modules

@router.post("/share", response_model=ModuleShareOut)
def share_module(
    share_data: ModuleShareCreate,
    db: Session = Depends(get_db),
    current_user: UserInDB = Depends(get_current_user),
):
    """
    Share a module with another user.
    """
    return ModuleShareService.create_share(db, share_data=share_data, from_user_id=current_user.id)

@router.get("/shared-with-me", response_model=List[SharedModuleOut])
def get_shared_with_me(
    db: Session = Depends(get_db),
    current_user: UserInDB = Depends(get_current_user),
):
    """
    Retrieve modules shared with the current user.
    """
    return ModuleShareService.get_shared_modules_for_user(db, user_id=current_user.id)

@router.put("/share/accept/{module_id}", response_model=ModuleShareOut)
def accept_share(
    module_id: UUID,
    db: Session = Depends(get_db),
    current_user: UserInDB = Depends(get_current_user),
):
    """
    Accept a module share request.
    """
    return ModuleShareService.accept_share(db, module_id=module_id, user_id=current_user.id)

@router.put("/publish/{module_id}", response_model=ModuleOut)
def publish_module(
    module_id: UUID,
    db: Session = Depends(get_db),
    current_user: UserInDB = Depends(get_current_user),
):
    """
    Publish a module to make it public.
    """
    return ModuleService.publish_module(db, module_id=module_id, user_id=current_user.id)

