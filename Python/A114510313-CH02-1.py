n = int(input("請輸入一個大於1的整數:"))
x, y, z = map(int, input("請輸入三個大於1整數，輸入值以逗號隔開:").split(","))

if 4/n == 1/x + 1/y + 1/z:
    print("True")
else:
    print("False")

#made in A114510313