from sqlalchemy.orm import Session
from passlib.context import CryptContext
from datetime import date, datetime, timedelta
from sqlalchemy import func
from uuid import UUID

from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

class UserService:
    @staticmethod
    def get_user_by_email(db: Session, email: str):
        return db.query(User).filter(User.email == email).first()

    @staticmethod
    def create_user(db: Session, user_data: UserCreate):
        hashed_password = pwd_context.hash(user_data.password)

        user = User(
            email=user_data.email,
            name=user_data.name,
            avatar_url=user_data.avatar_url,
            password_hash=hashed_password,
        )

        db.add(user)
        db.commit()
        db.refresh(user)
        return user

    @staticmethod
    def get_user_by_id(db: Session, user_id: UUID):
        return db.query(User).filter(User.id == user_id).first()

    @staticmethod
    def update_user(db: Session, user_id: UUID, user_data: UserUpdate):
        db_user = UserService.get_user_by_id(db, user_id)
        if not db_user:
            return None

        update_data = user_data.dict(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_user, key, value)

        db.add(db_user)
        db.commit()
        db.refresh(db_user)
        return db_user

    @staticmethod
    def verify_password(plain_password: str, hashed_password: str) -> bool:
        return pwd_context.verify(plain_password, hashed_password)

    @staticmethod
    def check_email_exists(db: Session, email: str) -> bool:
        return db.query(User).filter(User.email == email).first() is not None

    @staticmethod
    def get_all_users(db: Session):
        return db.query(User).all()
        
    @staticmethod
    def get_users_by_role(db: Session, role: str):
        return db.query(User).filter(User.role == role).all()

    @staticmethod
    def count_all_users(db: Session) -> int:
        return db.query(User).count()

    @staticmethod
    def count_users_registered_today(db: Session) -> int:
        today = date.today()
        return db.query(User).filter(func.date(User.created_at) == today).count()

    @staticmethod
    def count_users_registered_yesterday(db: Session) -> int:
        today = date.today()
        yesterday = today - timedelta(days=1)
        return db.query(User).filter(func.date(User.created_at) == yesterday).count()

    @staticmethod
    def get_user_registration_stats(db: Session):
        count_today = UserService.count_users_registered_today(db)
        count_yesterday = UserService.count_users_registered_yesterday(db)
        return {"count_today": count_today, "count_yesterday": count_yesterday}

    @staticmethod
    def count_users_registered_last_n_days(db: Session, days: int) -> int:
        end_date = datetime.utcnow()
        start_date = end_date - timedelta(days=days)
        return db.query(User).filter(User.created_at.between(start_date, end_date)).count()

    @staticmethod
    def get_user_weekly_registration_stats(db: Session):
        today = date.today()
        start_of_this_week = today - timedelta(days=today.weekday())
        end_of_this_week = start_of_this_week + timedelta(days=6)

        start_of_last_week = start_of_this_week - timedelta(days=7)
        end_of_last_week = start_of_last_week + timedelta(days=6)

        count_this_week = (
            db.query(User)
            .filter(func.date(User.created_at) >= start_of_this_week)
            .filter(func.date(User.created_at) <= end_of_this_week)
            .count()
        )

        count_last_week = (
            db.query(User)
            .filter(func.date(User.created_at) >= start_of_last_week)
            .filter(func.date(User.created_at) <= end_of_last_week)
            .count()
        )

        return {
            "count_this_week": count_this_week,
            "count_last_week": count_last_week,
        }

    @staticmethod
    def get_user_monthly_registration_stats(db: Session):
        today = date.today()

        # This month
        start_of_this_month = today.replace(day=1)
        if today.month == 12:
            first_day_of_next_month = date(today.year + 1, 1, 1)
        else:
            first_day_of_next_month = date(today.year, today.month + 1, 1)
        end_of_this_month = first_day_of_next_month - timedelta(days=1)

        # Last month
        end_of_last_month = start_of_this_month - timedelta(days=1)
        start_of_last_month = end_of_last_month.replace(day=1)

        count_this_month = (
            db.query(User)
            .filter(func.date(User.created_at) >= start_of_this_month)
            .filter(func.date(User.created_at) <= end_of_this_month)
            .count()
        )

        count_last_month = (
            db.query(User)
            .filter(func.date(User.created_at) >= start_of_last_month)
            .filter(func.date(User.created_at) <= end_of_last_month)
            .count()
        )

        return {
            "count_this_month": count_this_month,
            "count_last_month": count_last_month,
        }

    @staticmethod
    def get_user_yearly_registration_stats(db: Session):
        today = date.today()
        
        # This year
        start_of_this_year = today.replace(month=1, day=1)
        
        count_this_year = (
            db.query(User)
            .filter(func.date(User.created_at) >= start_of_this_year)
            .filter(func.date(User.created_at) <= today)
            .count()
        )

        # Last year same period
        last_year_today = today.replace(year=today.year - 1)
        start_of_last_year = last_year_today.replace(month=1, day=1)

        count_last_year = (
            db.query(User)
            .filter(func.date(User.created_at) >= start_of_last_year)
            .filter(func.date(User.created_at) <= last_year_today)
            .count()
        )

        return {
            "count_this_year": count_this_year,
            "count_last_year": count_last_year,
        }

    @staticmethod
    def count_users_by_month_current_year(db: Session):
        current_year = datetime.now().year
        
        results = (
            db.query(
                func.extract("month", User.created_at).label("month"),
                func.count(User.id).label("count"),
            )
            .filter(func.extract("year", User.created_at) == current_year)
            .group_by(func.extract("month", User.created_at))
            .order_by(func.extract("month", User.created_at))
            .all()
        )
        
        # Initialize counts for all months up to the current month
        current_month = datetime.now().month
        user_counts = [{"month": i, "count": 0} for i in range(1, current_month + 1)]

        for row in results:
            month_index = int(row.month) - 1
            if month_index < len(user_counts):
                user_counts[month_index]["count"] = row.count
        
        return user_counts

