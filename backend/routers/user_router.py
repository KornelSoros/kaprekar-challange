from datetime import timedelta

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlmodel import Session

from db.session import get_session
from models.user import UserRegister, User, UserPublic
from services.user_service import UserService, Token, ACCESS_TOKEN_EXPIRE_MINUTES, get_current_user, create_access_token

router = APIRouter(prefix="/user", tags=["User"])


@router.post("/register")
def register_user(*, session: Session = Depends(get_session), user: UserRegister):
    service = UserService(session)
    service.register_user(user)


@router.post("/login")
async def login_user(
        session: Session = Depends(get_session),
    form_data=Depends(OAuth2PasswordRequestForm),
) -> Token:
    service = UserService(session)
    user = service.authenticate_user(form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token = create_access_token(
        data={"sub": user.username}
    )
    return Token(access_token=access_token, token_type="bearer")


@router.get("/users/me/")
async def read_users_me(
    current_user: UserPublic = Depends(get_current_user),
) -> UserPublic:
    return current_user