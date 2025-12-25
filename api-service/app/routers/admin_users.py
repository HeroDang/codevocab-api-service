from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List

from app.db import get_db
from app.dependencies.authz import require_admin
from app.schemas.user import UserOut
from app.services.user_service import UserService

from app.schemas.user_analytics import UserCountByMonth, UserMonthlyRegistrationStats, UserRegistrationStats, UserWeeklyRegistrationStats, UserYearlyRegistrationStats

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

@router.get("/count/today", response_model=UserRegistrationStats)
def get_user_registration_stats_today(db: Session = Depends(get_db)):
    """
    Get the number of users registered today and yesterday. (Admin only)
    """
    return UserService.get_user_registration_stats(db)

@router.get("/count/last-week", response_model=UserWeeklyRegistrationStats)
def count_users_last_week(db: Session = Depends(get_db)):
    """
    Get the number of users registered in the current and previous week. (Admin only)
    """
    return UserService.get_user_weekly_registration_stats(db)

@router.get("/count/last-month", response_model=UserMonthlyRegistrationStats)
def count_users_last_month(db: Session = Depends(get_db)):
    """
    Get the number of users registered in the current and previous month. (Admin only)
    """
    return UserService.get_user_monthly_registration_stats(db)


@router.get("/count/last-year", response_model=UserYearlyRegistrationStats)
def count_users_last_year(db: Session = Depends(get_db)):
    """
    Get the number of users registered in the current year vs the same period last year. (Admin only)
    """
    return UserService.get_user_yearly_registration_stats(db)


@router.get("/count/by-month", response_model=List[UserCountByMonth])
def count_users_by_month(db: Session = Depends(get_db)):
    """
    Get the number of users registered by month for the current year. (Admin only)
    """
    return UserService.count_users_by_month_current_year(db)
