"""Import existing text records into csv."""

import csv
import re

from .models import CSV_FIELDNAMES, HealthRecord


HEADER_PATTERN = re.compile(r"(?m)^\[(?P<date>\d{4}/\d{2}/\d{2})\].*$")
NUMBER_PATTERN = r"(\d+(?:\.\d+)?)"


def ensure_csv_from_text(txt_path, csv_path):
    """Create the csv file from existing txt records when it does not exist."""

    if csv_path.exists():
        return

    records = []
    if txt_path.exists():
        records = parse_text_records(txt_path.read_text(encoding="utf-8-sig"))

    write_records_to_csv(records, csv_path)


def parse_text_records(text):
    """Parse old and new text record formats into HealthRecord objects."""

    matches = list(HEADER_PATTERN.finditer(text))
    records = []

    for index, match in enumerate(matches):
        start = match.start()
        end = matches[index + 1].start() if index + 1 < len(matches) else len(text)
        block = text[start:end].strip()

        if block:
            records.append(parse_record_block(block))

    return records


def parse_record_block(block):
    """Parse one text record block."""

    lines = block.splitlines()
    header = lines[0]
    date = _find_date(header) or ""
    height_cm = _first_unit_number(header, "cm")
    weight_kg = _first_unit_number(header, "kg")
    bmi = _labeled_number(header, "BMI")
    bmr = _labeled_number(header, "BMR")
    tdee = _labeled_number(header, "TDEE")
    gender = _labeled_text(header, "性別")
    age = _labeled_int(header, "年齡")
    activity_level, activity_label = _parse_activity(header)
    indulgence_day = _parse_indulgence(block)

    body_values = _parse_body_values(lines[1:])
    next_measure_date = _parse_next_measure_date(lines[1:])

    return HealthRecord(
        date=date,
        gender=gender,
        age=age,
        height_cm=height_cm,
        weight_kg=weight_kg,
        bmi=bmi,
        bmr=bmr,
        activity_level=activity_level,
        activity_label=activity_label,
        tdee=tdee,
        indulgence_day=indulgence_day,
        upper_chest_cm=body_values[0],
        lower_chest_cm=body_values[1],
        waist_cm=body_values[2],
        hip_cm=body_values[3],
        thigh_cm=body_values[4],
        next_measure_date=next_measure_date,
    )


def write_records_to_csv(records, csv_path):
    """Write parsed records to csv with a stable header."""

    csv_path.parent.mkdir(parents=True, exist_ok=True)
    with csv_path.open("w", newline="", encoding="utf-8-sig") as file:
        writer = csv.DictWriter(file, fieldnames=CSV_FIELDNAMES)
        writer.writeheader()
        for record in records:
            writer.writerow(record.to_csv_row())


def _find_date(text):
    match = re.search(r"\d{4}/\d{2}/\d{2}", text)
    return match.group(0) if match else None


def _first_unit_number(text, unit):
    match = re.search(rf"{NUMBER_PATTERN}\s*{re.escape(unit)}", text)
    return float(match.group(1)) if match else None


def _labeled_number(text, label):
    match = re.search(rf"{re.escape(label)}\s*[:：]\s*{NUMBER_PATTERN}", text)
    return float(match.group(1)) if match else None


def _labeled_int(text, label):
    value = _labeled_number(text, label)
    return int(value) if value is not None else None


def _labeled_text(text, label):
    match = re.search(rf"{re.escape(label)}\s*[:：]\s*([^\s]+)", text)
    return match.group(1) if match else ""


def _parse_activity(text):
    match = re.search(r"活動量\s*[:：]\s*([^\s]+)", text)
    if not match:
        return "", ""

    value = match.group(1)
    if "-" in value:
        key, label = value.split("-", 1)
        return key, label
    return value, ""


def _parse_indulgence(text):
    match = re.search(r"放縱日\s*[:：]\s*([^\s]+)", text)
    if not match:
        return None

    value = match.group(1)
    if value in {"是", "Y", "YES", "TRUE"}:
        return True
    if value in {"否", "N", "NO", "FALSE"}:
        return False
    return None


def _parse_body_values(lines):
    for line in lines:
        values = [float(value) for value in re.findall(rf"{NUMBER_PATTERN}\s*cm", line)]
        if len(values) >= 5:
            return values[:5]
    return [None, None, None, None, None]


def _parse_next_measure_date(lines):
    for line in lines:
        date = _find_date(line)
        if date:
            return date
    return None
