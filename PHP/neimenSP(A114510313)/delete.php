<?php
session_start();

// 檢查是否已登入，若未登入則導向登入頁面
if (!isset($_SESSION['username'])) {
    header("Location: login.php");
    exit;
}

require_once 'db_config.php'; // 引入資料庫連線設定

$pno = isset($_GET['pno']) ? intval($_GET['pno']) : 0;

if ($pno <= 0) {
    header("Location: home.php");
    exit;
}

$product = null;

try {
//取得將被刪除的當前資料
    $stmt = $pdo->prepare("SELECT pno,pname,ppic FROM products WHERE pno = :pno");
    $stmt->bindParam(':pno', $pno, PDO::PARAM_INT);
    $stmt->execute();
    $product = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$product){
        echo "<script>alert('未找到此景點資料。'); window.location,href='home.php';</script>";
        exit;
    }
} catch (PDOException $e) {
    die("查詢錯誤: " . $e->getMessage());
}

if (isset($_GET['confirm']) && $_GET['confirm'] === 'yes') {
    try {
        // 刪除資料庫記錄
     $stmt = $pdo->prepare("DELETE FROM products WHERE pno = :pno");
     $stmt->bindParam(':pno', $pno, PDO::PARAM_INT);
     $stmt->execute();

     //刪除此筆相關圖片
        $upload_dir = 'imgs/';
        if (!empty($product['ppic']) && file_exists($upload_dir.$product['ppic'])) {
            unlink($upload_dir.$product['ppic']);
        }

        header("Location: home.php"); // 刪除成功後導回首頁
        exit;
    } catch (PDOException $e) {
        die("刪除資料錯誤: " . $e->getMessage());
    }
}
?>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>確認刪除產品</title>
    <link rel="stylesheet" href="mystyle.css">
    <script>
        function confirmDelete() {
            if (confirm("確定要刪除景點活動 <?php echo $product['pname']; ?> (景點活動編號: <?php echo $product['pno']; ?>) 嗎？")) {
                window.location.href = "delete.php?pno=<?php echo $product['pno']; ?>&confirm=yes";
            } else {
                window.location.href = "home.php"; // 不確定則返回首頁
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <center><h1><U>內門區景點與特有活動資料管理系統_確認刪除景點活動</U></h1></center>
        <p>您確定要刪除景點活動：</p>
        <table>
            <tr>
                <th>景點活動編號</th>
                <td><?php echo $product['pno']; ?></td>
            </tr>
            <tr>
                <th>景點活動名稱</th>
                <td><?php echo $product['pname']; ?></td>
            </tr>
            <?php if (!empty($product['ppic'])): ?>
                <tr>
                    <th>景點活動圖片</th>
                    <td><img src="imgs/<?php echo $product['ppic']; ?>" alt="<?php echo $product['pname']; ?>" style="max-width: 100px; max-height: 100px;"></td>
                </tr>
            <?php endif; ?>
        </table>
        <button class="button cancel-button" onclick="confirmDelete()">確定刪除</button>
        <a href="home.php" class="button">取消</a>
    </div>
</body>
</html>
