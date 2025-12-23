from sqlalchemy.orm import Session
from uuid import UUID
from fastapi import HTTPException

from app.db_sql import sql
from app.models.words import Word
from app.schemas.words import WordCreate, WordUpdate

class WordService:

    @staticmethod
    def get_all(db: Session, limit: int = 50):
        return db.query(Word).limit(limit).all()

    @staticmethod
    def create(db: Session, data: WordCreate):
        new_word = Word(**data.model_dump())
        db.add(new_word)
        db.commit()
        db.refresh(new_word)
        return new_word

    @staticmethod
    def update(db: Session, word_id: UUID, data: WordUpdate):
        word = db.query(Word).filter(Word.id == word_id).first()
        if not word:
            raise HTTPException(status_code=404, detail="Word not found")

        for key, value in data.model_dump(exclude_unset=True).items():
            setattr(word, key, value)

        db.commit()
        db.refresh(word)
        return word

    @staticmethod
    def delete(db: Session, word_id: UUID):
        word = db.query(Word).filter(Word.id == word_id).first()
        if not word:
            raise HTTPException(status_code=404, detail="Word not found")

        db.delete(word)
        db.commit()
        return

    @staticmethod
    def search_complex(db, keyword: str):
        sqla = """
            SELECT w.id, w.text_en, w.ipa, w.meaning_vi 
            FROM words w
            WHERE w.text_en ILIKE :kw 
               OR w.meaning_vi ILIKE :kw
               OR w.ipa ILIKE :kw
            ORDER BY w.text_en
            LIMIT 50
        """
        return db.execute(sql(sqla), {"kw": f"%{keyword}%"}).fetchall()
