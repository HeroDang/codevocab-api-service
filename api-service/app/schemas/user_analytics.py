from pydantic import BaseModel

class UserCountByMonth(BaseModel):
    month: int
    count: int
