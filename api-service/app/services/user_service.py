from sqlalchemy.orm import Session
from passlib.context import CryptContext
from datetime import date, datetime, timedelta
from sqlalchemy import func

from app.models.user import User
from app.schemas.user import UserCreate

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
    def count_users_registered_last_n_days(db: Session, days: int) -> int:
        end_date = datetime.utcnow()
        start_date = end_date - timedelta(days=days)
        return db.query(User).filter(User.created_at.between(start_date, end_date)).count()

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

