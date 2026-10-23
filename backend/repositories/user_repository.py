from models.user import UserRegister, User
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
