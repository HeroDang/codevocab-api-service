from fastapi import FastAPI
from app.routers import words, modules

app = FastAPI(
    title="Server API Service - Vocabulary Backend",
    version="1.0.0"
)

# Routers
app.include_router(words.router, prefix="/words", tags=["Words"])
app.include_router(modules.router, prefix="/modules", tags=["Modules"])


@app.get("/")
def root():
    return {"message": "Server API Service is running!"}
