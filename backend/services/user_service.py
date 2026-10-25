import jwt
from fastapi import Depends, status, HTTPException
from fastapi.security import OAuth2PasswordBearer
from jwt.exceptions import InvalidTokenError
from pwdlib import PasswordHash
from sqlmodel import Session

from db.session import get_session
from models.user import UserRegister, User
from repositories.user_repository import UserRepository

from pydantic import BaseModel
from datetime import timedelta, datetime, timezone
from config.settings import settings

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/user/login")
password_hash = PasswordHash.recommended()

SECRET_KEY = settings.secret_key
ALGORITHM = settings.algorithm
ACCESS_TOKEN_EXPIRE_MINUTES = 30


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: str = None


def verify_password(plain_password, hashed_password):
    return password_hash.verify(plain_password, hashed_password)


def get_password_hash(password):
    return password_hash.hash(password)


async def get_current_user(token: str = Depends(oauth2_scheme), session: Session = Depends(get_session)):
    repo = UserRepository(session)
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username = payload.get("sub")
        if username is None:
            raise credentials_exception
        token_data = TokenData(username=username)
    except InvalidTokenError:
        raise credentials_exception
    user = repo.get_user(token_data.username)
    if user is None:
        raise credentials_exception
    return user


def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


class UserService:
    def __init__(self, session):
        self.repo = UserRepository(session)

    def register_user(self, user: UserRegister):
        hashed_password = get_password_hash(user.password)
        user_to_add = UserRegister(username = user.username, password = hashed_password)
        self.repo.register_user(user_to_add)

    def get_user(self, username: str):
        return self.repo.get_user(username)

    def authenticate_user(self, username: str, password: str):
        user = self.get_user(username)
        if not user:
            return False
        if not verify_password(password, user.password):
            return False
        return user





