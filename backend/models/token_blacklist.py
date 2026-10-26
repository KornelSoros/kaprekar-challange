from datetime import datetime

from sqlalchemy import Column, DateTime, func
from sqlmodel import SQLModel, Field


class TokenBlacklistCreate(SQLModel):
    token: str


class TokenBlacklist(TokenBlacklistCreate, table=True):
    __tablename__ = "token_blacklist"

    id: int | None = Field(default=None, primary_key=True)

    created_at: datetime | None = Field(
        default=None,
        sa_column=Column(
            DateTime(timezone=True),
            nullable=False,
            server_default=func.now(),
        ),
    )