"""Text and csv storage for health records."""

import csv
import re

from .models import CSV_FIELDNAMES


def save_record(record, txt_path, csv_path, replace_last=False):
    """Save one record to both txt and csv files."""

    append_text_record(record, txt_path, replace_last=replace_last)
    append_csv_record(record, csv_path, replace_last=replace_last)


def append_text_record(record, txt_path, replace_last=False):
    """Append or replace the last text record."""

    txt_path.parent.mkdir(parents=True, exist_ok=True)
    text = ""

    if txt_path.exists():
        text = txt_path.read_text(encoding="utf-8-sig")

    if replace_last:
        text = remove_last_text_record(text)

    if text and not text.endswith("\n"):
        text += "\n"
    if text and not text.endswith("\n\n"):
        text += "\n"

    txt_path.write_text(text + format_text_record(record), encoding="utf-8")


def append_csv_record(record, csv_path, replace_last=False):
    """Append or replace the last csv record."""

    rows = []

    if csv_path.exists():
        with csv_path.open("r", newline="", encoding="utf-8-sig") as file:
            rows = list(csv.DictReader(file))

    if replace_last and rows:
        rows.pop()

    rows.append(record.to_csv_row())
    csv_path.parent.mkdir(parents=True, exist_ok=True)

    with csv_path.open("w", newline="", encoding="utf-8-sig") as file:
        writer = csv.DictWriter(file, fieldnames=CSV_FIELDNAMES)
        writer.writeheader()
        writer.writerows(rows)


def remove_last_text_record(text):
    """Remove the last record block beginning with [YYYY/MM/DD]."""

    matches = list(re.finditer(r"(?m)^\[\d{4}/\d{2}/\d{2}\]", text))
    if not matches:
        return ""

    remaining = text[: matches[-1].start()].rstrip()
    return f"{remaining}\n\n" if remaining else ""


def format_text_record(record):
    """Format one record for health_record.txt."""

    lines = [
        (
            f"[{record.date}] 身高:{_format_number(record.height_cm)}cm "
            f"體重:{_format_number(record.weight_kg)}kg "
            f"BMI:{record.bmi:.2f} TDEE:{record.tdee:.0f} "
            f"昨日放縱日:{_format_yes_no(record.indulgence_day)}"
        ),
    ]

    if has_body_measurements(record):
        lines.append(
            f"上胸圍:{_format_number(record.upper_chest_cm)}cm "
            f"下胸圍:{_format_number(record.lower_chest_cm)}cm "
            f"腰圍:{_format_number(record.waist_cm)}cm "
            f"臀圍:{_format_number(record.hip_cm)}cm "
            f"大腿圍:{_format_number(record.thigh_cm)}cm"
        )
        lines.append(f"※ 建議於 {record.next_measure_date} 再次測量四圍數據，以觀察體態變化。")

    return "\n".join(lines) + "\n\n"


def has_body_measurements(record):
    """Return True when all body measurement fields are filled."""

    return all(
        value is not None
        for value in (
            record.upper_chest_cm,
            record.lower_chest_cm,
            record.waist_cm,
            record.hip_cm,
            record.thigh_cm,
        )
    )


def _format_number(value):
    return f"{value:g}"


def _format_yes_no(value):
    if value is None:
        return ""
    return "是" if value else "否"
