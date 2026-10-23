from sqlmodel import Session, create_engine

engine = create_engine("postgresql://krox:Ciga3002@localhost/kaprekar_db")

def get_session():
    with Session(engine) as session:
        yield session