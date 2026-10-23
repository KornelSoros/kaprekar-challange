from sqlalchemy import Column
from sqlalchemy.dialects.postgresql import JSONB
from sqlmodel import SQLModel, Field


class UserRegister(SQLModel):
    username: str
    password: str


class User(UserRegister, table = True):
    __tablename__ = "users"
    id: int = Field(default=None, primary_key=True)