from pydantic import BaseModel
from datetime import datetime
from uuid import UUID

class ModuleBase(BaseModel):
    name: str
    description: str | None = None
    parent_id: UUID | None = None
    is_public: bool = False

class ModuleCreate(ModuleBase):
    owner_id: UUID

# class ModuleOut(ModuleBase):
#     id: UUID

#     class Config:
#         orm_mode = True


class ModuleOut(BaseModel):
    id: UUID
    name: str
    description: str | None
    module_type: str
    is_public: bool
    created_at: datetime

    class Config:
        from_attributes = True