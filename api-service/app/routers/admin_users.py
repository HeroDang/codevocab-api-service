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

@router.get("/count/total", response_model=int)
def count_total_users(db: Session = Depends(get_db)):
    """
    Get the total number of users. (Admin only)
    """
    return UserService.count_all_users(db)

@router.get("/count/today", response_model=int)
def count_users_today(db: Session = Depends(get_db)):
    """
    Get the number of users registered today. (Admin only)
    """
    return UserService.count_users_registered_today(db)

@router.get("/count/last-week", response_model=int)
def count_users_last_week(db: Session = Depends(get_db)):
    """
    Get the number of users registered in the last 7 days. (Admin only)
    """
    return UserService.count_users_registered_last_n_days(db, days=7)

@router.get("/count/last-month", response_model=int)
def count_users_last_month(db: Session = Depends(get_db)):
    """
    Get the number of users registered in the last 30 days. (Admin only)
    """
    return UserService.count_users_registered_last_n_days(db, days=30)
