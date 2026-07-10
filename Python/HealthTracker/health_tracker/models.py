"""Data model for a health record."""

from dataclasses import dataclass
from typing import Optional


CSV_FIELDNAMES = [
    "date",
    "gender",
    "age",
    "height_cm",
    "weight_kg",
    "bmi",
    "bmr",
    "activity_level",
    "activity_label",
    "tdee",
    "indulgence_day",
    "upper_chest_cm",
    "lower_chest_cm",
    "waist_cm",
    "hip_cm",
    "thigh_cm",
    "next_measure_date",
]


@dataclass
class HealthRecord:
    """One saved health record."""

    date: str
    gender: str = ""
    age: Optional[int] = None
    height_cm: Optional[float] = None
    weight_kg: Optional[float] = None
    bmi: Optional[float] = None
    bmr: Optional[float] = None
    activity_level: str = ""
    activity_label: str = ""
    tdee: Optional[float] = None
    indulgence_day: Optional[bool] = None
    upper_chest_cm: Optional[float] = None
    lower_chest_cm: Optional[float] = None
    waist_cm: Optional[float] = None
    hip_cm: Optional[float] = None
    thigh_cm: Optional[float] = None
    next_measure_date: Optional[str] = None

    def to_csv_row(self):
        """Convert the record to a csv row."""

        return {
            "date": self.date,
            "gender": self.gender,
            "age": _format_optional(self.age),
            "height_cm": _format_optional(self.height_cm),
            "weight_kg": _format_optional(self.weight_kg),
            "bmi": _format_optional(self.bmi, digits=2),
            "bmr": _format_optional(self.bmr, digits=0),
            "activity_level": self.activity_level,
            "activity_label": self.activity_label,
            "tdee": _format_optional(self.tdee, digits=0),
            "indulgence_day": _format_bool(self.indulgence_day),
            "upper_chest_cm": _format_optional(self.upper_chest_cm),
            "lower_chest_cm": _format_optional(self.lower_chest_cm),
            "waist_cm": _format_optional(self.waist_cm),
            "hip_cm": _format_optional(self.hip_cm),
            "thigh_cm": _format_optional(self.thigh_cm),
            "next_measure_date": self.next_measure_date or "",
        }


def _format_optional(value, digits=None):
    if value is None:
        return ""
    if digits is None:
        return f"{value:g}"
    return f"{value:.{digits}f}"


def _format_bool(value):
    if value is None:
        return ""
    return "是" if value else "否"
