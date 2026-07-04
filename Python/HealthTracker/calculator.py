"""
calculator.py
=========================
健康數據計算模組

此模組負責所有與健康數據相關的數學計算，
包含 BMI、BMR、TDEE 等公式。

目的：
- 將所有公式集中管理。
- 主程式(main.py)只負責流程控制。
- 未來新增體脂率、FFMI、腰臀比等計算時，
  皆可直接加入此模組。
"""


def calculate_bmi(weight, height):
    """
    計算 BMI（Body Mass Index）。

    Parameters
    ----------
    weight : float
        體重（kg）

    height : float
        身高（cm）

    Returns
    -------
    float
        BMI 值
    """

    return weight / (height / 100) ** 2


def calculate_bmr(gender, age, height, weight):
    """
    計算 BMR（Basal Metabolic Rate）。

    採用 Mifflin-St Jeor Formula。

    Parameters
    ----------
    gender : str
        性別（M 或 F）

    age : int
        年齡

    height : float
        身高（cm）

    weight : float
        體重（kg）

    Returns
    -------
    float
        BMR（kcal/day）
    """

    if gender == "M":
        return 10 * weight + 6.25 * height - 5 * age + 5
    else:
        return 10 * weight + 6.25 * height - 5 * age - 161


def calculate_tdee(bmr, activity_level):
    """
    根據活動量計算 TDEE。

    Parameters
    ----------
    bmr : float
        基礎代謝率

    activity_level : str
        活動量等級（1~5）

    Returns
    -------
    float
        TDEE（kcal/day）
    """

    activity_factor = {
        "1": 1.2,
        "2": 1.375,
        "3": 1.55,
        "4": 1.725,
        "5": 1.9
    }

    factor = activity_factor.get(activity_level, 1.55)

    return bmr * factor