import random

class NumberService:

    def generate_4_digit_number(self):
        return random.randrange(1000, 10000)