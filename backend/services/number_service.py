import random
from sqlmodel import Session

from models.kaprekar_task import KaprekarTask
from repositories.number_repository import NumberRepository


class NumberService:
    def __init__(self, session: Session):
        self.repo = NumberRepository(session)

    def get_kaprekar_task_by_id(self, id: int) -> KaprekarTask | None:
        return self.repo.kaprekar_task_by_id(id)

    def add_new_kaprekar(self, kaprekar_num: int):
        steps = self.calculate_kaprekar_steps(kaprekar_num)
        self.repo.add_new_kaprekar(kaprekar_num, steps)


    def calculate_kaprekar_steps(self, num: int, steps = None):
        if steps is None:
            steps = []

        digits = [digit for digit in str(num)]
        digits.extend(["0"] * (4 - len(digits)))

        biggest_4_digit_num = int("".join(sorted(digits, reverse=True)).zfill(4))
        smallest_4_digit_num = int("".join(sorted(digits)).zfill(4))
        next_sum = biggest_4_digit_num - smallest_4_digit_num

        steps.append([biggest_4_digit_num, smallest_4_digit_num, next_sum])

        if next_sum != 0 and next_sum != 6174:
            return self.calculate_kaprekar_steps(next_sum, steps)

        else:
            return steps

