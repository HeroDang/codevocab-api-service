from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from pydantic import BaseModel
from uuid import UUID

from app.db import get_db
from app.services.user_service import UserService
from app.dependencies.authz import require_user

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
