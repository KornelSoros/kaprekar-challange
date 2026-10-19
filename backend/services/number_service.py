import random

class NumberService:

    def generate_4_digit_number(self):
        return random.randrange(1000, 10000)

    def get_kaprekar(self, num: int):
        digits = [digit for digit in str(num)]
        digits.extend(["0"] * (4 - len(digits)))

        biggest_4_digit_num = int("".join(sorted(digits, reverse=True)).zfill(4))
        smallest_4_digit_num = int("".join(sorted(digits)).zfill(4))
        next_sum = biggest_4_digit_num - smallest_4_digit_num

        if next_sum != 0 and next_sum != 6174:
            print(f"{biggest_4_digit_num} - {smallest_4_digit_num} = {next_sum}")
            self.get_kaprekar(next_sum)

        else:
            print(f"{biggest_4_digit_num} - {smallest_4_digit_num} = {next_sum}")