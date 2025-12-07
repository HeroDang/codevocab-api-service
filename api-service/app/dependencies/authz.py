from fastapi import Depends, HTTPException, status
from app.schemas.auth import UserInDB
from app.routers.auth import get_current_user

def require_user(current_user: UserInDB = Depends(get_current_user)):
    if current_user.disabled:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="User is disabled"
        )
    return current_user


def require_admin(current_user: UserInDB = Depends(get_current_user)):
    if current_user.role != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Admin only"
        )
    return current_user
