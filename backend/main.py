from fastapi import FastAPI
from routers import num_router

app = FastAPI(description="Kaprekar Challenge Backend")

app.include_router(num_router)