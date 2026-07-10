"""Input helpers for the command-line program."""

from .calculations import ACTIVITY_LEVELS


GENDER_ALIASES = {
    "M": "M",
    "MALE": "M",
    "男": "M",
    "F": "F",
    "FEMALE": "F",
    "女": "F",
}


def normalize_gender(value):
    """Normalize gender input to M or F."""

    gender = GENDER_ALIASES.get(value.strip().upper())
    if gender is None:
        raise ValueError("性別請輸入 M/F 或 男/女")
    return gender


def ask_basic_profile():
    """Ask for gender, age, height, and weight."""

    prompt = "請輸入性別(M/F), 年齡, 身高(cm), 體重(kg)，用逗號分隔："

    while True:
        raw_input_data = input(prompt)
        parts = [part.strip() for part in raw_input_data.split(",")]

        if len(parts) != 4:
            print("格式不正確，範例：F, 30, 165, 60")
            continue

        try:
            gender = normalize_gender(parts[0])
            age = int(parts[1])
            height_cm = float(parts[2])
            weight_kg = float(parts[3])

            if age <= 0 or height_cm <= 0 or weight_kg <= 0:
                raise ValueError("年齡、身高、體重都必須大於 0")

            return gender, age, height_cm, weight_kg
        except ValueError as exc:
            print(f"輸入錯誤：{exc}")


def ask_positive_float(prompt):
    """Ask for a positive floating-point number."""

    while True:
        try:
            value = float(input(prompt).strip())
            if value <= 0:
                raise ValueError
            return value
        except ValueError:
            print("請輸入大於 0 的數字。")


def ask_yes_no(prompt):
    """Ask a yes/no question and return True for yes."""

    while True:
        answer = input(prompt).strip().upper()
        if answer == "Y":
            return True
        if answer == "N":
            return False
        print("請輸入 Y 或 N。")


def ask_activity_level():
    """Ask for activity level."""

    print("\n請選擇活動量：")
    for level in ACTIVITY_LEVELS.values():
        print(f"{level.key}. {level.label}（{level.description}）")

    while True:
        choice = input("請輸入活動量代號(1-5)：").strip()
        activity = ACTIVITY_LEVELS.get(choice)
        if activity is not None:
            return activity
        print("活動量代號不正確，請輸入 1-5。")
