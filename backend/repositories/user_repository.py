from models.token_blacklist import TokenBlacklist, TokenBlacklistCreate
from models.user import UserRegister, User, UserPublic
from sqlmodel import Session, select


class UserRepository:

    def __init__(self, session: Session):
        self.session = session

    def get_user(self, username: str):
        statement = select(User).where(User.username == username)
        user_found = self.session.exec(statement).first()
        return user_found

    def register_user(self, user: UserRegister):
        user_to_add = User.model_validate(user)

        self.session.add(user_to_add)
        self.session.commit()
        self.session.refresh(user_to_add)

    def logout_user(self, token: str):
        token_to_blacklist = TokenBlacklistCreate(token=token)
        token_to_add = TokenBlacklist.model_validate(token_to_blacklist)
        self.session.add(token_to_add)
        self.session.commit()
        self.session.refresh(token_to_add)


    def is_token_blacklisted(self, token: str):
        statement = select(TokenBlacklist).where(TokenBlacklist.token == token)
        token_from_database = self.session.exec(statement).first()
        return token_from_database is not None