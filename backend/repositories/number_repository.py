from sqlmodel import Session, select
from typing import List
from models.kaprekar_task import KaprekarTask


class NumberRepository:
    def __init__(self, session: Session):
        self.session = session

    def get_all_kaprekar_tasks(self) -> List[KaprekarTask]:
        statement = select(KaprekarTask)
        return self.session.exec(statement).all()

    def kaprekar_task_by_id(self, id: int) -> KaprekarTask | None:
        return self.session.get(KaprekarTask, id)

    def add_new_kaprekar(self, kaprekar_num: int, steps: dict):
        new_kaprekar_task = KaprekarTask(starting_num = kaprekar_num, solution_steps = steps)
        self.session.add(new_kaprekar_task)
        self.session.commit()
        self.session.refresh(new_kaprekar_task)