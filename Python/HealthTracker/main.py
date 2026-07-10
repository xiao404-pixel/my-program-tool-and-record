"""Command-line entry point for the health tracker."""

from datetime import datetime, timedelta
from pathlib import Path

from health_tracker.body_measurements import ask_body_measurements
from health_tracker.calculations import calculate_bmi, calculate_bmr, calculate_tdee
from health_tracker.input_handler import (
    ask_activity_level,
    ask_basic_profile,
    ask_yes_no,
)
from health_tracker.legacy_import import ensure_csv_from_text
from health_tracker.models import HealthRecord
from health_tracker.recommendations import print_recommendations
from health_tracker.storage import save_record


BASE_DIR = Path(__file__).resolve().parent
TXT_PATH = BASE_DIR / "health_record.txt"
CSV_PATH = TXT_PATH.with_suffix(".csv")


def main():
    """Collect one health record and save it to txt and csv files."""

    ensure_csv_from_text(TXT_PATH, CSV_PATH)

    gender, age, height_cm, weight_kg = ask_basic_profile()
    bmi = calculate_bmi(weight_kg, height_cm)
    bmr = calculate_bmr(gender, age, height_cm, weight_kg)

    print("-" * 30)
    print(f"你的 BMI 為：{bmi:.2f}")
    print(f"你的基礎代謝率(BMR)為：{bmr:.0f} 大卡")

    activity = ask_activity_level()
    tdee = calculate_tdee(bmr, activity.factor)

    print(f"你的每日總消耗熱量(TDEE)約為：{tdee:.0f} 大卡")

    indulgence_day = ask_yes_no("\n昨日是否為放縱日？(Y/N)：")
    now = datetime.now()
    next_measure_date = (now + timedelta(days=14)).strftime("%Y/%m/%d")
    body_measurements = ask_body_measurements(next_measure_date)

    record = HealthRecord(
        date=now.strftime("%Y/%m/%d"),
        gender=gender,
        age=age,
        height_cm=height_cm,
        weight_kg=weight_kg,
        bmi=bmi,
        bmr=bmr,
        activity_level=activity.key,
        activity_label=activity.label,
        tdee=tdee,
        indulgence_day=indulgence_day,
        **body_measurements,
    )

    print("-" * 30)
    print_recommendations(record)

    replace_last = ask_yes_no("\n是否覆蓋上一筆資料？(Y/N)：")
    save_record(record, TXT_PATH, CSV_PATH, replace_last=replace_last)

    print("-" * 30)
    print(f"資料已儲存至 {TXT_PATH.name} 與 {CSV_PATH.name}")
    print("下次量測時可直接執行 main.py 新增紀錄。")


if __name__ == "__main__":
    main()
