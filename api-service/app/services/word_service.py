from sqlalchemy.orm import Session

from app.db_sql import sql
from app.models.words import Word
from app.schemas.words import WordCreate

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
