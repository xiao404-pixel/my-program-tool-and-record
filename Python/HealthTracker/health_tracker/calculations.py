"""BMI, BMR, and TDEE calculations."""

from dataclasses import dataclass


@dataclass(frozen=True)
class ActivityLevel:
    """Activity level metadata for TDEE calculation."""

    key: str
    label: str
    description: str
    factor: float


ACTIVITY_LEVELS = {
    "1": ActivityLevel("1", "久坐", "幾乎不運動", 1.2),
    "2": ActivityLevel("2", "輕度活動", "每週運動 1-3 天", 1.375),
    "3": ActivityLevel("3", "中度活動", "每週運動 3-5 天", 1.55),
    "4": ActivityLevel("4", "高度活動", "每週運動 6-7 天", 1.725),
    "5": ActivityLevel("5", "非常高度活動", "高強度訓練或體力工作", 1.9),
}


def calculate_bmi(weight_kg, height_cm):
    """Calculate body mass index."""

    return weight_kg / (height_cm / 100) ** 2


def calculate_bmr(gender, age, height_cm, weight_kg):
    """Calculate basal metabolic rate using the Mifflin-St Jeor equation."""

    base = 10 * weight_kg + 6.25 * height_cm - 5 * age
    if gender == "M":
        return base + 5
    return base - 161


def calculate_tdee(bmr, activity_factor):
    """Calculate total daily energy expenditure."""

    return bmr * activity_factor
