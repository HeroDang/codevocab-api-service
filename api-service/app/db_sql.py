from sqlalchemy import text

def sql(query: str):
    return text(query)
