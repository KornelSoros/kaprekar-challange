import random

from fastapi import APIRouter, Depends
from sqlmodel import Session

from db.session import get_session
from services.number_service import NumberService

router = APIRouter(prefix="/number", tags=["Number"])


@router.get("/all_kaprekar_tasks")
def get_all_kaprekar_tasks(session: Session = Depends(get_session)):
    service = NumberService(session)
    return service.get_akk_kaprekar_tasks()
@router.get("/get_random_number")
def get_random_4_digit_number(id: int, session: Session = Depends(get_session)):
    service = NumberService(session)
    return service.get_kaprekar_task_by_id(id)

@router.post("/add_random_kaprekar")
def add_kaprekar_number(session = Depends(get_session)):
    kaprekar_num = random.randrange(1000,10000)

    service = NumberService(session)
    service.add_new_kaprekar(kaprekar_num)
