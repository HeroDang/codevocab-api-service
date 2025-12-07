from datetime import datetime, timedelta
from typing import Optional, Dict

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from jose import JWTError, jwt
from passlib.context import CryptContext
from uuid import UUID
from pydantic import BaseModel

from app.db import get_db
from app.schemas.user import UserCreate, UserOut, RegisterAndLoginResponse
from app.services.user_service import (
    get_user_by_email,
    create_user,
    check_email_exists,
    verify_password
)

# ==========================
# Cấu hình JWT (tạm thời)
# ==========================
SECRET_KEY = "change_this_to_a_long_random_secret_key"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60  # 1 giờ
DEV_BYPASS_EMAILS = ["admin", "user"]  # email login dev
DEV_BYPASS_PASSWORD = "12345"

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="auth/token")

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

router = APIRouter(
    prefix="/auth",
    tags=["auth"],
)

# ==========================
# Pydantic models
# ==========================
class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: Optional[str] = None


class User(BaseModel):
    id: UUID
    email: str
    name: Optional[str] = None
    avatar_url: Optional[str] = None
    disabled: Optional[bool] = None

    class Config:
        orm_mode = True


class UserInDB(User):
    hashed_password: str


# ==========================
# Fake user DB (tạm thời)
# Sau này sẽ thay bằng PostgreSQL
# ==========================
def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)


fake_users_db: Dict[str, Dict] = {
    "hung": {
        "username": "hung",
        "full_name": "Hung Demo",
        "email": "hung@example.com",
        "hashed_password": get_password_hash("password123"),  # mật khẩu demo
        "disabled": False,
    }
}


# ==========================
# Helpers
# ==========================
def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)


def get_user(db: Dict[str, Dict], username: str) -> Optional[UserInDB]:
    user_dict = db.get(username)
    if user_dict:
        return UserInDB(**user_dict)
    return None


def authenticate_user(db: Dict[str, Dict], username: str, password: str) -> Optional[UserInDB]:
    user = get_user(db, username)
    if not user:
        return None
    if not verify_password(password, user.hashed_password):
        return None
    return user


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=15))
    to_encode.update({"exp": expire})
    # "sub" (subject) thường là username
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db)
):
    credentials_exception = HTTPException(
        status_code=401,
        detail="Không thể xác thực token.",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email = payload.get("sub")
        if email is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception

    user = get_user_by_email(db, email)
    if not user:
        raise credentials_exception

    return user


async def get_current_active_user(current_user: UserInDB = Depends(get_current_user)) -> UserInDB:
    if current_user.disabled:
        raise HTTPException(status_code=400, detail="Tài khoản đã bị vô hiệu hóa")
    return current_user


# ==========================
# ROUTES
# ==========================

@router.post("/token", response_model=Token)
async def login_for_access_token(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db)
):
    email = form_data.username
    password = form_data.password

    user = get_user_by_email(db, email)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Sai email hoặc mật khẩu",
        )

    # ======================================================
    # DEV MODE: bypass password cho admin / user
    # ======================================================
    if email in DEV_BYPASS_EMAILS and password == DEV_BYPASS_PASSWORD:
        access_token = create_access_token(data={"sub": email})
        return {"access_token": access_token, "token_type": "bearer"}
    # ======================================================

    # 🔐 PRODUCTION MODE — verify bcrypt bình thường
    if not verify_password(password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Sai email hoặc mật khẩu",
        )

    access_token = create_access_token(data={"sub": email})
    return {"access_token": access_token, "token_type": "bearer"}


@router.post("/register", response_model=UserOut)
async def register_user(
    user_data: UserCreate,
    db: Session = Depends(get_db)
):
    # Check duplicate email
    if check_email_exists(db, user_data.email):
        raise HTTPException(
            status_code=400,
            detail="Email đã tồn tại"
        )

    # Create user
    new_user = create_user(db, user_data)

    return new_user

@router.post("/register-login", response_model=RegisterAndLoginResponse)
async def register_and_login(
    user_data: UserCreate,
    db: Session = Depends(get_db)
):
    # Check duplicate email
    if check_email_exists(db, user_data.email):
        raise HTTPException(
            status_code=400,
            detail="Email đã tồn tại"
        )

    # Create user
    new_user = create_user(db, user_data)

    # Create token automatically
    access_token = create_access_token(
        data={"sub": new_user.email}
    )

    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": new_user
    }



@router.get("/me", response_model=User)
async def read_users_me(
    current_user: User = Depends(get_current_active_user),
):
    """
    Test endpoint cần Bearer token.
    """
    return current_user
