from datetime import datetime, timedelta

# =========================
# 1. 輸入基本資料
# =========================
raw_input_data = input(
    "請輸入 性別(M/F), 年齡, 身高(cm), 體重(kg)，以逗號隔開："
)

parts = raw_input_data.split(',')

gender = parts[0].strip().upper()
age = int(parts[1])
h = float(parts[2])
w = float(parts[3])

# =========================
# 2. 計算 BMI
# =========================
bmi = w / (h / 100) ** 2

print("-" * 30)
print(f"您的 BMI 為：{bmi:.2f}")

# =========================
# 3. 計算 BMR
# =========================
if gender == "M":
    bmr = 10 * w + 6.25 * h - 5 * age + 5
else:
    bmr = 10 * w + 6.25 * h - 5 * age - 161

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

if activity_level == "1":
    tdee = bmr * 1.2
elif activity_level == "2":
    tdee = bmr * 1.375
elif activity_level == "3":
    tdee = bmr * 1.55
elif activity_level == "4":
    tdee = bmr * 1.725
elif activity_level == "5":
    tdee = bmr * 1.9
else:
    print("輸入錯誤，預設以中度活動量計算！")
    tdee = bmr * 1.55

print(f"您的每日總消耗熱量 (TDEE) 為：{tdee:.0f} 大卡")

#=========================
# 5. 放縱日選擇
#========================= 
indulgence_day = input("\n前日是否為放縱日？(Y/N)：").strip().upper() 
indulgence_record = "" 
if indulgence_day == "Y": 
    indulgence_record = "前日為放縱日\n" 
elif indulgence_day == "N":
    indulgence_record = "前日非放縱日\n" 
else: 
    indulgence_record = "前日放縱日狀態：未確認\n" 

# =========================
# 5. 飲食建議
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
# 6. 取得目前日期時間
# =========================
now = datetime.now()

time_str = now.strftime("[%Y/%m/%d]")

# 計算兩週後日期
next_measure_date = (
    now + timedelta(days=14)
).strftime("%Y/%m/%d")

# =========================
# 7. 是否輸入四圍
# =========================
body_choice = input("\n是否輸入四圍數據？(Y/N)：").strip().upper()

body_record = ""

if body_choice == "Y":

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

# =========================
# 8. 建立紀錄內容
# =========================
record = (
    f"{time_str} "
    f"身高:{h}cm "
    f"體重:{w}kg "
    f"BMI:{bmi:.2f} "
    f"TDEE:{tdee:.0f}\n"
    f"{body_record}\n"
)

# =========================
# 9. 是否覆蓋上一筆
# =========================
choice = input("是否覆蓋上一筆資料？(Y/N)：").strip().upper()

filename = "health_record.txt"

if choice == "Y":

    try:
        # 讀取舊資料
        with open(filename, "r", encoding="utf-8") as file:
            lines = file.readlines()

        # 移除最後空白行
        while lines and lines[-1].strip() == "":
            lines.pop()

        # 找到上一筆紀錄開始位置
        for i in range(len(lines) - 1, -1, -1):

            if lines[i].startswith("["):
                lines = lines[:i]
                break

        # 覆蓋寫回
        with open(filename, "w", encoding="utf-8") as file:
            file.writelines(lines)
            file.write(record)

        print("上一筆資料已覆蓋！")

    except FileNotFoundError:

        # 若檔案不存在則建立
        with open(filename, "w", encoding="utf-8") as file:
            file.write(record)

        print("找不到舊檔案，已建立新紀錄！")

else:

    # 新增資料
    with open(filename, "a", encoding="utf-8") as file:
        file.write(record)

    print("資料已新增！")

# =========================
# 10. 完成訊息
# =========================
print("-" * 30)
print("健康資料已儲存至 health_record.txt")
print("感謝使用健康紀錄器！")