from sqlalchemy import Column, String, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
from sqlalchemy import DateTime
import uuid

from sqlalchemy.ext.declarative import declarative_base
Base = declarative_base()

class Word(Base):
    __tablename__ = "words"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    text_en = Column(String, nullable=False)
    meaning_vi = Column(Text)
    part_of_speech = Column(String)
    ipa = Column(String)
    example_sentence = Column(Text)
    audio_url = Column(String)
    created_at = Column(DateTime, server_default=func.now())
