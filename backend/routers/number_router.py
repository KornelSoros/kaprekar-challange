from fastapi import APIRouter, Depends
from sqlmodel import Session

from db.session import get_session
from services.number_service import NumberService

router = APIRouter(prefix="/number", tags=["Number"])

@router.get("/get_random_number")
def get_random_4_digit_number(session: Session = Depends(get_session)):
    service = NumberService()
    service.get_kaprekar(5518)
    return service.generate_4_digit_number()