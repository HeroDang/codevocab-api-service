from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
import uuid

from app.db import get_db
from app.services.user_profile_service import UserProfileService, get_user_profile_service
from app.schemas.user_profile import UserProfile, UserProfileBase, UserProfileUpdatePhonemes

router = APIRouter(
    prefix="/user-profiles",
    tags=["User Profiles"],
    responses={404: {"description": "Not found"}},
)

@router.get("/{user_id}/weak-phonemes", response_model=UserProfileBase)
def get_user_weak_phonemes(
    user_id: uuid.UUID,
    user_profile_service: UserProfileService = Depends(get_user_profile_service)
):
    user_profile = user_profile_service.get_weak_phonemes_by_user_id(user_id)
    if user_profile is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Weak phonemes not found for this user."
        )
    return user_profile

@router.patch("/{user_id}/weak-phonemes", response_model=UserProfile)
def update_user_weak_phonemes(
    user_id: uuid.UUID,
    update_data: UserProfileUpdatePhonemes,
    user_profile_service: UserProfileService = Depends(get_user_profile_service)
):
    """
    Cập nhật danh sách âm tiết yếu. 
    Input là mảng json ["ph1", "ph2"], value của mỗi âm tiết sẽ được +1.
    """
    updated_profile = user_profile_service.update_weak_phonemes(
        user_id=user_id, 
        phonemes_to_update=update_data.phonemes
    )
    
    if updated_profile is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User profile not found."
        )
        
    return updated_profile