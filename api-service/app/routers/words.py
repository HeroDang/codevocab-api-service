from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.db import get_db
from app.db_sql import sql
from app.schemas.words import WordCreate, WordResponse, WordListCreate, WordUpdate

from app.services.word_service import WordService
from app.dependencies.authz import require_user
from app.routers.auth import get_current_user
from app.schemas.auth import UserInDB
from uuid import UUID

router = APIRouter(
    prefix="/words",
    tags=["words"],
    dependencies=[Depends(require_user)]
)

@router.post("/", response_model=WordResponse)
def create_word(data: WordCreate, db: Session = Depends(get_db)):
    return WordService.create(db, data)

@router.post("/list", response_model=list[WordResponse])
def create_word_list(data: WordListCreate, db: Session = Depends(get_db)):
    return WordService.create_words_with_module(db, data)

@router.put("/{word_id}", response_model=WordResponse)
def update_word(
    word_id: UUID,
    data: WordUpdate,
    db: Session = Depends(get_db),
):
    return WordService.update(db, word_id, data)

@router.delete("/{word_id}")
def delete_word(
    word_id: UUID,
    db: Session = Depends(get_db),
    current_user: UserInDB = Depends(get_current_user),
):
    return WordService.delete(db, word_id, current_user.id)
