from fastapi import APIRouter
from services.number_service import NumberService

router = APIRouter(prefix="/number", tags=["Number"])

@router.get("/get_random_number")
def get_random_4_digit_number():
    service = NumberService()
    return service.generate_4_digit_number()