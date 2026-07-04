from calculator import (
    calculate_bmi,
    calculate_bmr,
    calculate_tdee
)

from utils import (
    get_today_string,
    get_next_measure_date
)

# =========================
# 1. 輸入基本資料
# =========================
basic_input = input(
    "請輸入 性別(M/F), 年齡, 身高(cm), 體重(kg)，以逗號隔開："
)

input_parts = basic_input.split(',')

gender = input_parts[0].strip().upper()
age = int(input_parts[1])
height = float(input_parts[2])
weight = float(input_parts[3])

# =========================
# 2. 計算 BMI
# =========================
bmi = calculate_bmi(weight, height)

print("-" * 30)
print(f"您的 BMI 為：{bmi:.2f}")

# =========================
# 3. 計算 BMR
# =========================
bmr = calculate_bmr(
    gender,
    age,
    height,
    weight
)

print(f"您的基礎代謝率 (BMR) 為：{bmr:.0f} 大卡")

# =========================
# 4. 活動量選擇
# =========================
print("\n請選擇您的活動量：")
print("1. 輕度 (每週運動 1-3 天)")
print("2. 中度 (每週運動 3-5 天)")
print("3. 高度 (每週運動 6 天)")
print("4. 很高度 (每週運動 6-7 天)")
print("5. 非常高度 (體力勞動或每日雙重訓練)")

activity_level = input("請輸入數字 (1-5)：")

tdee = calculate_tdee(
    bmr,
    activity_level
)

print(f"您的每日總消耗熱量 (TDEE) 為：{tdee:.0f} 大卡")

# =========================
# 5. 放縱日選擇
# =========================
indulgence_day = input(
    "\n前日是否為放縱日？(Y/N)："
).strip().upper()

indulgence_record = ""

if indulgence_day == "Y":
    indulgence_record = "前日為放縱日\n"
elif indulgence_day == "N":
    indulgence_record = "前日非放縱日\n"
else:
    indulgence_record = "前日放縱日狀態：未確認\n"

# =========================
# 6. 飲食建議
# =========================
print("-" * 30)

if bmi > 24:
    print("【減重建議】")
    print(
        f"為了安全減重，建議每日攝取約 "
        f"{tdee - 500:.0f} ~ {tdee - 300:.0f} 大卡。"
    )
    print("搭配原型食物與規律運動，效果會更好喔！")

elif bmi < 18.5:
    print("【增重建議】")
    print(f"建議每日攝取約 {tdee + 300:.0f} 大卡。")
    print("並搭配重量訓練增加肌肉量。")

else:
    print("【維持建議】")
    print(f"每日攝取約 {tdee:.0f} 大卡即可維持現狀。")
    print("請繼續保持均衡飲食與運動習慣！")

# =========================
# 7. 日期
# =========================
record_date = get_today_string()
next_measure_date = get_next_measure_date()

# =========================
# 8. 是否輸入四圍
# =========================
record_body_measurements = input("\n是否輸入四圍數據？(Y/N)：").strip().upper()

body_record = ""

if record_body_measurements == "Y":

    upper_chest = input("請輸入上胸圍(cm)：")
    lower_chest = input("請輸入下胸圍(cm)：")
    waist = input("請輸入腰圍(cm)：")
    hip = input("請輸入臀圍(cm)：")
    thigh = input("請輸入大腿圍(cm)：")

    body_record = (
        f"上胸圍:{upper_chest}cm "
        f"下胸圍:{lower_chest}cm "
        f"腰圍:{waist}cm "
        f"臀圍:{hip}cm "
        f"大腿圍:{thigh}cm\n"
        f"※ 建議於 {next_measure_date} "
        f"再次測量四圍數據，以觀察體態變化。\n"
    )

# 後面的 TXT 紀錄、覆蓋、新增等程式碼維持原樣即可