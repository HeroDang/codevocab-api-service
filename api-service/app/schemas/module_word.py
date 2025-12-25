from pydantic import BaseModel
from uuid import UUID
from typing import List

class ModuleWordsDelete(BaseModel):
    word_id: UUID

class ModuleWordsUpdate(BaseModel):
    word_ids: List[UUID]

class AddWordsToModule(BaseModel):
    module_id: UUID
    word_ids: List[UUID]
