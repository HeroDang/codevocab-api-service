from pydantic import BaseModel
from typing import Optional
from uuid import UUID

# ==========================================================
# JWT Token trả về sau khi login
# ==========================================================
class Token(BaseModel):
    access_token: str
    token_type: str


# ==========================================================
# Payload decode từ JWT
# ==========================================================
class TokenData(BaseModel):
    user_id: Optional[UUID] = None
    email: Optional[str] = None
    role: Optional[str] = None


# ==========================================================
# UserInDB – dùng nội bộ Auth, không trả ra ngoài
# ==========================================================
class UserInDB(BaseModel):
    id: UUID
    email: str
    name: Optional[str] = None
    avatar_url: Optional[str] = None
    disabled: Optional[bool] = None
    hashed_password: str

    class Config:
        orm_mode = True
