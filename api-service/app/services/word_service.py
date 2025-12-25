from sqlalchemy.orm import Session
from uuid import UUID
from fastapi import HTTPException

from app.db_sql import sql
from app.models.words import Word
from app.models.modules import Module
from app.models.module_word import ModuleWord
from app.schemas.words import WordCreate, WordUpdate
from app.models.word_delete import WordDelete
import datetime

from app.schemas.words import WordCreate, WordUpdate, WordListCreate

class WordService:

    @staticmethod
    def get_all(db: Session, limit: int = 50):
        return db.query(Word).outerjoin(WordDelete, Word.id == WordDelete.word_id).filter(WordDelete.word_id.is_(None)).limit(limit).all()

    @staticmethod
    def get_all_admin(db: Session):
        return db.query(Word).outerjoin(WordDelete, Word.id == WordDelete.word_id).filter(WordDelete.word_id.is_(None)).all()

    @staticmethod
    def search_words_admin(db: Session, module_id: UUID | None = None, user_id: UUID | None = None):
        query = db.query(Word).outerjoin(WordDelete, Word.id == WordDelete.word_id).filter(WordDelete.word_id.is_(None))

        if module_id and user_id:
            query = query.join(ModuleWord, Word.id == ModuleWord.word_id) \
                         .join(Module, Module.id == ModuleWord.module_id) \
                         .filter(Module.id == module_id) \
                         .filter(Module.owner_id == user_id)
        elif module_id:
            query = query.join(ModuleWord, Word.id == ModuleWord.word_id).filter(ModuleWord.module_id == module_id)
        elif user_id:
            query = query.join(ModuleWord, Word.id == ModuleWord.word_id) \
                         .join(Module, Module.id == ModuleWord.module_id) \
                         .filter(Module.owner_id == user_id)

        return query.distinct().all()

    @staticmethod
    def create(db: Session, data: WordCreate):
        new_word = Word(**data.model_dump())
        db.add(new_word)
        db.commit()
        db.refresh(new_word)
        return new_word

    @staticmethod
    def create_words_with_module(db: Session, data: WordListCreate):
        new_words = []
        for word_data in data.words:
            new_word = Word(**word_data.model_dump())
            db.add(new_word)
            db.flush()  # Flush to get the new_word.id

            module_word = ModuleWord(module_id=data.module_id, word_id=new_word.id)
            db.add(module_word)
            new_words.append(new_word)

        db.commit()
        for word in new_words:
            db.refresh(word)
            
        return new_words

    @staticmethod
    def update(db: Session, word_id: UUID, data: WordUpdate):
        word = db.query(Word).outerjoin(WordDelete, Word.id == WordDelete.word_id).filter(Word.id == word_id, WordDelete.word_id.is_(None)).first()
        if not word:
            raise HTTPException(status_code=404, detail="Word not found")

        for key, value in data.model_dump(exclude_unset=True).items():
            setattr(word, key, value)

        db.commit()
        db.refresh(word)
        return word

    @staticmethod
    def delete(db: Session, word_id: UUID, user_id: UUID):
        word = db.query(Word).outerjoin(WordDelete, Word.id == WordDelete.word_id).filter(Word.id == word_id, WordDelete.word_id.is_(None)).first()
        if not word:
            raise HTTPException(status_code=404, detail="Word not found")
            
        existing_delete = db.query(WordDelete).filter(WordDelete.word_id == word_id).first()
        if existing_delete:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Word already deleted")

        word.deleted_at = datetime.datetime.utcnow()
        
        new_word_delete = WordDelete(word_id=word_id, user_id=user_id)
        db.add(new_word_delete)
        
        db.commit()
        return {"message": "Word deleted successfully"}

    @staticmethod
    def search_complex(db, keyword: str):
        sqla = """
            SELECT w.id, w.text_en, w.ipa, w.meaning_vi 
            FROM words w
            LEFT OUTER JOIN word_deletes wd ON w.id = wd.word_id
            WHERE (w.text_en ILIKE :kw 
               OR w.meaning_vi ILIKE :kw
               OR w.ipa ILIKE :kw)
               AND wd.word_id IS NULL
            ORDER BY w.text_en
            LIMIT 50
        """
        return db.execute(sql(sqla), {"kw": f"%{keyword}%"}).fetchall()

    @staticmethod
    def search_by_module_admin(db: Session, module_id: UUID):
        from app.models.module_word import ModuleWord
        return db.query(Word).join(ModuleWord, Word.id == ModuleWord.word_id).outerjoin(WordDelete, Word.id == WordDelete.word_id).filter(ModuleWord.module_id == module_id, WordDelete.word_id.is_(None)).all()
