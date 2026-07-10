"""Health recommendation output."""


def print_recommendations(record):
    """Print simple calorie recommendations."""

    for line in build_recommendations(record.bmi, record.tdee):
        print(line)


def build_recommendations(bmi, tdee):
    """Build recommendation lines from BMI and TDEE."""

    if bmi > 24:
        return [
            "目前 BMI 偏高。",
            f"若以減脂為目標，可先抓每日 {tdee - 500:.0f} ~ {tdee - 300:.0f} 大卡。",
            "建議搭配規律阻力訓練、足量蛋白質與穩定睡眠。",
        ]

    if bmi < 18.5:
        return [
            "目前 BMI 偏低。",
            f"若以增重為目標，可先抓每日約 {tdee + 300:.0f} 大卡。",
            "建議以漸進式訓練與營養密度高的食物增加體重。",
        ]

    return [
        "目前 BMI 在一般範圍。",
        f"可先以每日約 {tdee:.0f} 大卡作為維持熱量參考。",
        "建議持續記錄體重與圍度變化，觀察趨勢再微調。",
    ]
