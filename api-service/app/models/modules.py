from sqlalchemy import Column, Text, Boolean, DateTime, ForeignKey, String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from app.db import Base

import uuid

class Module(Base):
    __tablename__ = "modules"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)

    owner_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"))
    parent_id = Column(UUID(as_uuid=True), ForeignKey("modules.id", ondelete="CASCADE"), nullable=True)

    name = Column(Text, nullable=False)
    description = Column(Text)

    module_type = Column(String(20), nullable=False, default="personal")
    is_public = Column(Boolean, default=False)

    created_at = Column(DateTime, server_default=func.now())
