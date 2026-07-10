"""Body measurement collection and formatting."""

from input_handler import ask_positive_number, ask_yes_no


def ask_body_measurements(next_measure_date):
    """Ask whether to record measurements and collect them if needed."""

    should_record = ask_yes_no("\n是否輸入身體四圍？(Y/N)：")

    if not should_record:
        return None

    return {
        "upper_chest": ask_positive_number("請輸入上胸圍(cm)："),
        "lower_chest": ask_positive_number("請輸入下胸圍(cm)："),
        "waist": ask_positive_number("請輸入腰圍(cm)："),
        "hip": ask_positive_number("請輸入臀圍(cm)："),
        "thigh": ask_positive_number("請輸入大腿圍(cm)："),
        "next_measure_date": next_measure_date,
    }


def format_body_measurements(measurements):
    """Format body measurements for the text record."""

    if measurements is None:
        return ""

    return (
        f"上胸圍:{measurements['upper_chest']:g}cm "
        f"下胸圍:{measurements['lower_chest']:g}cm "
        f"腰圍:{measurements['waist']:g}cm "
        f"臀圍:{measurements['hip']:g}cm "
        f"大腿圍:{measurements['thigh']:g}cm\n"
        f"下次建議量測日期：{measurements['next_measure_date']}\n"
    )
