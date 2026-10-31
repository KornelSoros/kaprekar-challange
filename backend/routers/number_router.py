import random

from fastapi import APIRouter, Depends
from sqlmodel import Session

from db.session import get_session
from models.user import UserPublic
from services.number_service import NumberService
from services.user_service import get_current_user
from typing import List

router = APIRouter(prefix="/number", tags=["Number"], dependencies=[Depends(get_current_user)])


@router.get("/all_kaprekar_tasks")
def get_all_kaprekar_tasks(session: Session = Depends(get_session)):
    service = NumberService(session)
    return service.get_akk_kaprekar_tasks()

@router.get("/kaprekar_tasks_by_user_id")
def get_all_kaprekar_tasks_by_user_id(session: Session = Depends(get_session), current_user: UserPublic = Depends(get_current_user)):
    service = NumberService(session)

    return service.get_akk_kaprekar_tasks_by_user_id(current_user.id)

@router.post("/add_random_kaprekar")
def add_kaprekar_number(session = Depends(get_session), current_user: UserPublic = Depends(get_current_user)):
    kaprekar_num = random.randrange(1000,10000)

    service = NumberService(session)
    service.add_new_kaprekar(kaprekar_num, current_user.id)

@router.put("/send_solution")
def send_kaprekar_solution(kaprekar_id: int, solution_steps: List[List[int]], session: Session = Depends(get_session)):
    service = NumberService(session)
    kaprekar_task = service.get_kaprekar_task_by_id(kaprekar_id)
    correct_steps = service.calculate_kaprekar_steps(kaprekar_task.starting_num)

    shorter_solution_steps = min(len(solution_steps), len(correct_steps))

    total_score = len(correct_steps) * 3
    earned_score = 0
    for i in range(shorter_solution_steps):
        for j in range(3):
            if solution_steps[i][j] == correct_steps[i][j]:
                earned_score += 1

    service.set_solutions_and_scores(kaprekar_task, solution_steps, correct_steps, earned_score, total_score)
