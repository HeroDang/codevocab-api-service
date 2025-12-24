from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.db import get_db
from app.db_sql import sql
from app.schemas.words import WordCreate, WordResponse
from app.services.word_service import WordService
from app.dependencies.authz import require_user
from app.routers.auth import get_current_user
from app.schemas.auth import UserInDB
from uuid import UUID

router = APIRouter(
    prefix="/words",
    tags=["words"],
    dependencies=[Depends(require_user)]   # BẢO VỆ TOÀN ROUTER
)  

@router.get("/sql")
def get_words(db: Session = Depends(get_db)):
    result = db.execute(sql("SELECT w.id, w.text_en, w.meaning_vi, w.ipa FROM words w LEFT OUTER JOIN word_deletes wd ON w.id = wd.word_id WHERE wd.word_id IS NULL LIMIT 20;"))
    data = [{"id": str(r[0]), "text_en": r[1], "meaning_vi": r[2]} for r in result]
    return {"words": data}

@router.get("/search")
def search(keyword: str, db: Session = Depends(get_db)):
    result = WordService.search_complex(db, keyword)
    return [{"id": r.id, "text_en": r.text_en, "meaning_vi": r.meaning_vi} for r in result]

@router.get("/", response_model=list[WordResponse])
def list_words(db: Session = Depends(get_db)):
    return WordService.get_all(db)

@router.post("/", response_model=WordResponse)
def create_word(data: WordCreate, db: Session = Depends(get_db)):
    return WordService.create(db, data)

@router.delete("/{word_id}")
def delete_word(
    word_id: UUID,
    db: Session = Depends(get_db),
    current_user: UserInDB = Depends(get_current_user),
):
    return WordService.delete(db, word_id, current_user.id)
