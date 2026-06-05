#江惠宇
for i in range(3):
    num = input()
    cnt = ((int(num[0]) + int(num[2]) \
            + int(num[4])) + \
            ((int(num[1]) + int(num[3]))*5)) % 26
    if cnt == ord(num[-1])-ord('A')+1:
        print('pass')
    else:
        print('fail')