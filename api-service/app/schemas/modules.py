from pydantic import BaseModel
from uuid import UUID

class ModuleBase(BaseModel):
    name: str
    description: str | None = None
    parent_id: UUID | None = None
    is_public: bool = False

class ModuleCreate(ModuleBase):
    owner_id: UUID

class ModuleResponse(ModuleBase):
    id: UUID

    class Config:
        orm_mode = True
