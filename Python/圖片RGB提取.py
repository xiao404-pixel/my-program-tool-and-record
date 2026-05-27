import cv2

# 讀取圖片
image = cv2.imread(r'C:\Users\river\Downloads\image_8ed9f1fd.png')

# 將 BGR 轉換為 RGB
image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

# 分離三個通道
R = image_rgb[:, :, 0]
G = image_rgb[:, :, 1]
B = image_rgb[:, :, 2]

print("紅色通道陣列形狀:", R.shape)
print("綠色通道陣列形狀:", G.shape)
print("藍色通道陣列形狀:", B.shape)

# 若要顯示特定區域的數值
print("前 5x5 像素的紅色分量:\n", R[:5, :5])
print("前 5x5 像素的綠色分量:\n", G[:5, :5])
print("前 5x5 像素的藍色分量:\n", B[:5, :5])