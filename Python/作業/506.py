#江惠宇

a = int(input())
lst = []

for x in range(2,int(a/2)+1):
    while a % x == 0:
        a /= x
        lst.append(str(x))

if len(lst) == 0:
    print("-1")
else:
    print('*'.join(lst))
    