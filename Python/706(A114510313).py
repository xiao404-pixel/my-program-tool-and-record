#江惠宇

a = []
for i in range(4):
    a.append(int(input()))

with open ('read.txt','r') as f:
    for i in f:
        a.append(int(i))
a.sort()

with open ('write.txt','w') as f:
    for i in a:
        print(i)
        f.write(str(i)+'\n')