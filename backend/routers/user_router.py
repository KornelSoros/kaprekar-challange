from fastapi import APIRouter, Depends
from sqlmodel import Session

from db.session import get_session
from models.user import UserRegister
from services.user_service import UserService

router = APIRouter(prefix="/user", tags=["User"])


@router.post("/register")
def register_user(*, session: Session = Depends(get_session), user: UserRegister):
    service = UserService(session)
    service.register_user(user)