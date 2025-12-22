from pydantic import BaseModel
from typing import List
from uuid import UUID
from datetime import datetime

class ModuleBase(BaseModel):
    name: str
    description: str | None = None
    parent_id: UUID | None = None
    is_public: bool = False

class ModuleCreate(ModuleBase):
    owner_id: UUID

class ModuleUpdate(BaseModel):
    name: str | None = None
    description: str | None = None
    is_public: bool | None = None

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

class ModuleChildOut(BaseModel):
    id: UUID
    name: str
    description: str = None
    module_type: str
    is_public: bool
    created_at: datetime

    class Config:
        from_attributes = True


class ModuleDetailOut(BaseModel):
    id: UUID
    name: str
    description: str = None
    module_type: str
    is_public: bool
    created_at: datetime

    children: List[ModuleChildOut] = []

    class Config:
        from_attributes = True