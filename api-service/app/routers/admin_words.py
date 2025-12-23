from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from uuid import UUID

from app.db import get_db
from app.dependencies.authz import require_admin
from app.services.word_service import WordService
from app.schemas.words import WordCreate, WordUpdate, WordOut

router = APIRouter(
    prefix="/admin/words",
    tags=["admin-words"],
    dependencies=[Depends(require_admin)],
)

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

@router.delete("/{word_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_word(
    word_id: UUID,
    db: Session = Depends(get_db)
):
    """
    Delete a word. (Admin only)
    """
    WordService.delete(db, word_id)
    return
