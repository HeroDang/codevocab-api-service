from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List

from app.db import get_db
from app.dependencies.authz import require_admin
from app.schemas.user import UserOut
from app.services.user_service import UserService

router = APIRouter(
    prefix="/admin/users",
    tags=["admin-users"],
    dependencies=[Depends(require_admin)],
)

@router.get("/", response_model=List[UserOut])
def get_user_accounts(db: Session = Depends(get_db)):
    """
    Get all user accounts with role 'user'. (Admin only)
    """
    users = UserService.get_users_by_role(db, role="user")
    return users
