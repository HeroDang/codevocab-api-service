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

