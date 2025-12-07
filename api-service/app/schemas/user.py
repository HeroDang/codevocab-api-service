from pydantic import BaseModel, EmailStr
from uuid import UUID

# ==========================================================
# Shared fields
# ==========================================================
class UserBase(BaseModel):
    email: EmailStr
    name: str | None = None
    avatar_url: str | None = None
    disabled: bool | None = False


# ==========================================================
# Schema trả về ra ngoài API
# ==========================================================
class UserOut(UserBase):
    id: UUID

    class Config:
        orm_mode = True


# ==========================================================
# Schema tạo user (Signup)
# ==========================================================
class UserCreate(BaseModel):
    email: EmailStr
    password: str
    name: str | None = None
    avatar_url: str | None = None

class RegisterAndLoginResponse(BaseModel):
    access_token: str
    token_type: str
    user: UserOut
