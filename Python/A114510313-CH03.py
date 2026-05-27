c = eval(input("請輸入學生的國文成績>"))
e = eval(input("請輸入學生的英文成績>"))
m = eval(input("請輸入學生的數學成績>"))

avg = (c + e + m) / 3

if c > 80 and e > 60 and m > 60:
    level = "特優"
elif avg > 70 and c > 60 and e > 60 and m > 60:
    level = "優等"
elif avg > 60:
    level = "普通"
else:
    level = "待加強"

print("國文：", c, "分，英文：", e, "分，數學：", m, "分，評定等級：", level, "")

#made in A114510313