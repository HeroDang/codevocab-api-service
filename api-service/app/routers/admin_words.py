from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from uuid import UUID
from typing import List, Optional

from app.db import get_db
from app.dependencies.authz import require_admin
from app.services.word_service import WordService
from app.schemas.words import WordCreate, WordUpdate, WordOut, WordCreateWithModule

router = APIRouter(
    prefix="/admin/words",
    tags=["admin-words"],
    dependencies=[Depends(require_admin)],
)

@router.get("/", response_model=List[WordOut])
def search_words_admin(
    db: Session = Depends(get_db),
    module_id: Optional[UUID] = Query(None, description="Filter words by module ID"),
    user_id: Optional[UUID] = Query(None, description="Filter words by user ID (owner of the module)")
):
    """
    Retrieve all words, with optional filtering by module_id and user_id. (Admin only)
    """
    return WordService.search_words_admin(db, module_id=module_id, user_id=user_id)

@router.post("/", response_model=WordOut, status_code=status.HTTP_201_CREATED)
def create_word(
    data: WordCreate,
    db: Session = Depends(get_db)
):
    """
    Create a new word. (Admin only)
    """
    return WordService.create(db, data)

@router.post("/with-module", response_model=WordOut, status_code=status.HTTP_201_CREATED)
def create_word_with_module(
    data: WordCreateWithModule,
    db: Session = Depends(get_db)
):
    """
    Create a new word and associate it with a module. (Admin only)
    """
    return WordService.create_word_with_module(db, data)

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
