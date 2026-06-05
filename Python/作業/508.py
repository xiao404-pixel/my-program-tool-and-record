#江惠宇
a = input()
b = input()

ans = int(a,2) + int(b,2)
print(f"{int(a,2)} + {int(b,2)} = {ans}")

binadd = bin(ans)[2:]
print(f"{11111111 if len(binadd)>8 else binadd}")