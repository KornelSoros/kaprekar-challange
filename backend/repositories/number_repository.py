from sqlmodel import Session, select
from typing import List
from models.kaprekar_task import KaprekarTask


class NumberRepository:
    def __init__(self, session: Session):
        self.session = session

    def get_all_kaprekar_tasks(self) -> List[KaprekarTask]:
        statement = select(KaprekarTask)
        return list(self.session.exec(statement).all())

    def get_kaprekar_tasks_by_user_id(self, user_id: int) -> List[KaprekarTask]:
        statement = select(KaprekarTask).where(KaprekarTask.user_id == user_id)
        return list(self.session.exec(statement).all())

    def kaprekar_task_by_id(self, id: int) -> KaprekarTask | None:
        return self.session.get(KaprekarTask, id)

    def set_solutions_and_scores(self, kaprekar_task: KaprekarTask, submitted_steps: list[list[int]], correct_steps: list[list[int]], earned_score: int, total_score: int):
        kaprekar_task.submitted_steps = submitted_steps
        kaprekar_task.solution_steps = correct_steps
        kaprekar_task.earned_score = earned_score
        kaprekar_task.total_score = total_score
        self.session.add(kaprekar_task)
        self.session.commit()
        self.session.refresh(kaprekar_task)

    def add_new_kaprekar(self, kaprekar_num: int, user_id: int):
        new_kaprekar_task = KaprekarTask(starting_num = kaprekar_num, user_id=user_id)
        self.session.add(new_kaprekar_task)
        self.session.commit()
        self.session.refresh(new_kaprekar_task)