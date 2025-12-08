from pydantic import BaseModel
from uuid import UUID
from datetime import datetime

class GroupBase(BaseModel):
    name: str

class GroupCreate(BaseModel):
    name: str

class GroupOut(GroupBase):
    id: UUID
    owner_id: UUID

    model_config = {
        "from_attributes": True
    }


class GroupMemberOut(BaseModel):
    id: UUID
    user_id: UUID
    group_id: UUID
    joined_at: datetime | None = None

    model_config = {
        "from_attributes": True
    }
