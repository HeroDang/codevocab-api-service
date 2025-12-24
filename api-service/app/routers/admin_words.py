from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from uuid import UUID
from typing import List

from app.db import get_db
from app.dependencies.authz import require_admin
from app.services.word_service import WordService
from app.schemas.words import WordCreate, WordUpdate, WordOut

router = APIRouter(
    prefix="/admin/words",
    tags=["admin-words"],
    dependencies=[Depends(require_admin)],
)

@router.get("/", response_model=List[WordOut])
def get_all_words_admin(
    db: Session = Depends(get_db)
):
    """
    Retrieve all words. (Admin only)
    """
    return WordService.get_all_admin(db)

@router.get("/search/{module_id}", response_model=List[WordOut])
def search_words_by_module_admin(
    module_id: UUID,
    db: Session = Depends(get_db)
):
    """
    Retrieve all words for a specific module. (Admin only)
    """
    return WordService.search_by_module_admin(db, module_id=module_id)

@router.post("/", response_model=WordOut, status_code=status.HTTP_201_CREATED)
def create_word(
    data: WordCreate,
    db: Session = Depends(get_db)
):
    """
    Create a new word. (Admin only)
    """
    return WordService.create(db, data)

@router.put("/{word_id}", response_model=WordOut)
def update_word(
    word_id: UUID,
    data: WordUpdate,
    db: Session = Depends(get_db)
):
    """
    Update an existing word. (Admin only)
    """
    return WordService.update(db, word_id, data)

from app.schemas.auth import UserInDB

@router.delete("/{word_id}", status_code=status.HTTP_200_OK)
def delete_word(
    word_id: UUID,
    db: Session = Depends(get_db),
    current_user: UserInDB = Depends(require_admin)
):
    """
    Delete a word. (Admin only)
    """
    return WordService.delete(db, word_id, current_user.id)
