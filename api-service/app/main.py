from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.routers import words, modules, auth, admin_modules, groups, dictionary

app = FastAPI(
    title="Server API Service - Vocabulary Backend",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],     # sửa lại sau: app mobile domain, dev domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routers
app.include_router(auth.router)
app.include_router(admin_modules.router)
app.include_router(words.router)
app.include_router(modules.router)
app.include_router(groups.router)
app.include_router(dictionary.router)


@app.get("/")
def root():
    return {"message": "Server API Service is running!"}
