from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
from uuid import UUID

from app.db import get_db
from app.services.user_service import UserService
from app.dependencies.authz import require_user
from app.routers.auth import get_current_user
from app.schemas.auth import UserInDB
from app.schemas.user import UserUpdate, UserOut

router = APIRouter(
    prefix="/users",
    tags=["Users"],
    dependencies=[Depends(require_user)],
)

class EmailCheckResponse(BaseModel):
    exists: bool
    userId: UUID | None = None

@router.get("/check-email/{email}", response_model=EmailCheckResponse)
def check_email_exists(
    email: str,
    db: Session = Depends(get_db),
):
    """
    Check if an email exists in the system.
    """
    user = UserService.get_user_by_email(db, email=email)
    if user:
        return {"exists": True, "userId": user.id}
    else:
        return {"exists": False, "userId": None}


@router.get("/me", response_model=UserOut)
def read_me(current_user: UserInDB = Depends(get_current_user)):
    """
    Get current user's information.
    """
    return current_user


@router.put("/me", response_model=UserOut)
def update_me(
    user_update: UserUpdate,
    db: Session = Depends(get_db),
    current_user: UserInDB = Depends(get_current_user)
):
    """
    Update current user's information (name, avatar_url).
    """
    updated_user = UserService.update_user(db, user_id=current_user.id, user_data=user_update)
    if not updated_user:
        raise HTTPException(status_code=404, detail="User not found")
    return updated_user
