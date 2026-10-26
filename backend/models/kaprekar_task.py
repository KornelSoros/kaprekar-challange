from sqlalchemy import Column
from sqlalchemy.dialects.postgresql import JSONB
from sqlmodel import SQLModel, Field

class KaprekarTask(SQLModel, table = True):
    __tablename__ =  "kaprekar_tasks"
    id: int = Field(default=None, primary_key=True)
    starting_num: int
    solution_steps: list[list[int]] = Field(sa_type=JSONB)
    user_id: int = Field(foreign_key="users.id")