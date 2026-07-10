"""Body measurement collection."""

from .input_handler import ask_positive_float, ask_yes_no


BODY_FIELDS = {
    "upper_chest_cm": "上胸圍",
    "lower_chest_cm": "下胸圍",
    "waist_cm": "腰圍",
    "hip_cm": "臀圍",
    "thigh_cm": "大腿圍",
}


def ask_body_measurements(next_measure_date):
    """Ask whether to record body measurements and collect them if needed."""

    measurements = {
        "upper_chest_cm": None,
        "lower_chest_cm": None,
        "waist_cm": None,
        "hip_cm": None,
        "thigh_cm": None,
        "next_measure_date": None,
    }

    if not ask_yes_no("\n是否輸入四圍數據？(Y/N)："):
        return measurements

    for field, label in BODY_FIELDS.items():
        measurements[field] = ask_positive_float(f"請輸入{label}(cm)：")

    measurements["next_measure_date"] = next_measure_date
    return measurements
