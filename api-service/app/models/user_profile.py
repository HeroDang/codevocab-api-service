from sqlalchemy import Column, String, DateTime, ForeignKey
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import uuid

from app.db import Base

class UserProfile(Base):
    __tablename__ = "user_profiles"

    user_id = Column(UUID(as_uuid=True), primary_key=True)
    full_name = Column(String(255), nullable=True)
    level = Column(String(50), default="beginner")
    weak_phonemes = Column(JSONB, default={})
    last_practice_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
