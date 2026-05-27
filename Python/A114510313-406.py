file1=open("favorite.txt","w")
while True:
    content=input("輸入喜歡的水果:")
    if content!= '9999':
        file1.write(content+"\n")
    else:
        break
print("結束")
file1.close()