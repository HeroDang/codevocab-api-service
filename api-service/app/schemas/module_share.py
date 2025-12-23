from pydantic import BaseModel
from uuid import UUID
from datetime import datetime
from app.schemas.modules import MyModuleOut

class ModuleShareBase(BaseModel):
    to_user: UUID
    module_id: UUID

class ModuleShareCreate(ModuleShareBase):
    pass

class ModuleShareOut(ModuleShareBase):
    id: UUID
    from_user: UUID
    status: str
    created_at: datetime

    class Config:
        from_attributes = True

class SharedModuleOut(MyModuleOut):
    status: str
