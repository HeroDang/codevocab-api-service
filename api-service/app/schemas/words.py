from pydantic import BaseModel
from uuid import UUID

class WordBase(BaseModel):
    text_en: str
    meaning_vi: str | None = None
    part_of_speech: str | None = None
    ipa: str | None = None
    example_sentence: str | None = None

class WordCreate(WordBase):
    pass

class WordResponse(WordBase):
    id: UUID

    class Config:
        orm_mode = True
