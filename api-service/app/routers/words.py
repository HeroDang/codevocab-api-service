from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.db import get_db
from app.db_sql import sql
from app.schemas.words import WordCreate, WordResponse
from app.services.word_service import WordService

router = APIRouter()

@router.get("/sql")
def get_words(db: Session = Depends(get_db)):
    result = db.execute(sql("SELECT id, text_en, meaning_vi, ipa FROM words LIMIT 20;"))
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
