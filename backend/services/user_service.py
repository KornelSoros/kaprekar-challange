from fastapi.security import OAuth2PasswordBearer
from pwdlib import PasswordHash

from models.user import UserRegister, User
from repositories.user_repository import UserRepository

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
password_hash = PasswordHash.recommended()


def verify_password(plain_password, hashed_password):
    return password_hash.verify(plain_password, hashed_password)


def get_password_hash(password):
    return password_hash.hash(password)

class UserService:
    def __init__(self, session):
        self.repo = UserRepository(session)

    def register_user(self, user: UserRegister):
        hashed_password = get_password_hash(user.password)
        user_to_add = UserRegister(username = user.username, password = hashed_password)
        self.repo.register_user(user_to_add)
