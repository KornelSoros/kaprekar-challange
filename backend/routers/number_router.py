from fastapi import APIRouter, Depends
from sqlmodel import Session

from db.session import get_session
from services.number_service import NumberService

router = APIRouter(prefix="/number", tags=["Number"])

@router.get("/get_random_number")
def get_random_4_digit_number(id: int, session: Session = Depends(get_session)):
    service = NumberService(session)
    return service.get_kaprekar_task_by_id(id)


@router.post("/add_random_kaprekar")
def add_kaprekar_number(kaprekar_num: int, session = Depends(get_session)):
    service = NumberService(session)
    service.add_new_kaprekar(kaprekar_num)
