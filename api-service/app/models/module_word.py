from sqlalchemy import Column
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func

from app.db import Base


class ModuleWord(Base):
    __tablename__ = "module_words"

    id = Column(UUID(as_uuid=True), primary_key=True, server_default=func.gen_random_uuid())

    module_id = Column(
        UUID(as_uuid=True),
        nullable=False,
    )

    word_id = Column(
        UUID(as_uuid=True),
        nullable=False,
    )
