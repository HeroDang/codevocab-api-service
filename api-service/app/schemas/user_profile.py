from pydantic import BaseModel
from typing import Dict, Any, Optional, List
import uuid

class UserProfileBase(BaseModel):
    weak_phonemes: Dict[str, Any] = {}
    level: Optional[str]

class UserProfileUpdatePhonemes(BaseModel):
    phonemes: List[str]

class UserProfileWeakPhonemesAndLevel(BaseModel):
    weak_phonemes: Dict[str, Any] = {}
    level: Optional[str]

class UserProfile(UserProfileBase):
    user_id: uuid.UUID

    class Config:
        orm_mode = True
