from pydantic import BaseModel

class UserCountByMonth(BaseModel):
    month: int
    count: int

class UserRegistrationStats(BaseModel):
    count_today: int
    count_yesterday: int

class UserWeeklyRegistrationStats(BaseModel):
    count_this_week: int
    count_last_week: int

class UserMonthlyRegistrationStats(BaseModel):
    count_this_month: int
    count_last_month: int

class UserYearlyRegistrationStats(BaseModel):
    count_this_year: int
    count_last_year: int
