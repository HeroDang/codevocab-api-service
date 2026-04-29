from sqlalchemy.orm import Session
from fastapi import Depends
import uuid

from app.db import get_db
from app.models.user_profile import UserProfile

class UserProfileService:
    def __init__(self, db: Session):
        self.db = db

    def get_weak_phonemes_by_user_id(self, user_id: uuid.UUID):
        user_profile = self.db.query(UserProfile).filter(UserProfile.user_id == user_id).first()
        if user_profile:
            return user_profile
        return None

    def get_profile_by_user_id(self, user_id: uuid.UUID):
        return self.db.query(UserProfile).filter(UserProfile.user_id == user_id).first()

    def update_weak_phonemes(self, user_id: uuid.UUID, phonemes_to_update: list[str]):
        # 1. Tìm profile theo user_id
        user_profile = self.db.query(UserProfile).filter(UserProfile.user_id == user_id).first()
        
        if not user_profile:
            return None

        # 2. Lấy dict weak_phonemes hiện tại (đảm bảo là dict)
        current_weak_phonemes = dict(user_profile.weak_phonemes) if user_profile.weak_phonemes else {}

        # 3. Duyệt mảng input và tăng giá trị +1
        for phoneme in phonemes_to_update:
            if phoneme in current_weak_phonemes:
                current_weak_phonemes[phoneme] += 1
            else:
                current_weak_phonemes[phoneme] = 1

        # 4. Gán lại và thông báo cho SQLAlchemy về sự thay đổi (đối với kiểu JSON/Dict)
        user_profile.weak_phonemes = current_weak_phonemes
        
        # Lưu vào database
        self.db.add(user_profile)
        self.db.commit()
        self.db.refresh(user_profile)
        
        return user_profile

def get_user_profile_service(db: Session = Depends(get_db)):
    return UserProfileService(db)
