from fastapi import FastAPI
import random

app = FastAPI(description="Kaprekar Challenge Backend")


@app.get("/get_random_number")
def get_random_4_digit_number():
    return random.randrange(1000, 10000)