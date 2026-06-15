<?php
session_start();

// 檢查是否已登入，若未登入則導向登入頁面
if (!isset($_SESSION['username'])) {
    header("Location: login.php");
    exit;
}

require_once 'db_config.php'; // 引入資料庫連線設定

$pno = isset($_GET['pno']) ? intval($_GET['pno']) : 0;//當前此筆的pno景點活動編號

if ($pno <= 0) {
    header("Location: home.php");
    exit;
}

$product = null;//當前的一筆景點活動資料
$upload_error = '';//發生錯誤

try {
    //$stmt = $pdo->prepare("SELECT pno, pname, pptime, pscrib, ppic FROM products WHERE pno = :pno");//取得目前此筆的資料SQL
    $stmt = $pdo->prepare("SELECT pno, pname, pscrib, ppic FROM products WHERE pno = :pno");//取得目前此筆的資料SQL
    $stmt->bindParam(':pno', $pno, PDO::PARAM_INT);//連結pno參數
    $stmt->execute();//確實執行SQL
    $product = $stmt->fetch(PDO::FETCH_ASSOC);//
    if (!$product) {
        header("Location: home.php"); // 找不到產品則導回首頁
        exit;
    }
} catch (PDOException $e) {
    die("查詢錯誤: " . $e->getMessage());
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $pname = $_POST['pname'];
    $pscrib = $_POST['pscrib'];
    $old_ppic = $_POST['old_ppic'];
    // 處理圖片上傳
    if (isset($_FILES['ppic']) && $_FILES['ppic']['error'] === UPLOAD_ERR_OK) {
        $allowed_types = ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'];
        if (in_array($_FILES['ppic']['type'], $allowed_types)) {
            $upload_dir = 'imgs/';
            $file_extension = pathinfo($_FILES['ppic']['name'], PATHINFO_EXTENSION);
            $new_filename = uniqid() . '.' . $file_extension; // 產生唯一檔名
            $upload_path = $upload_dir . $new_filename;

            if (move_uploaded_file($_FILES['ppic']['tmp_name'], $upload_path)) {
                // 上傳成功，更新圖片檔名，並刪除舊的圖片
                $ppic = $new_filename;
                if (!empty($old_ppic) && file_exists($upload_dir . $old_ppic)) {
                    unlink($upload_dir . $old_ppic);
                }
            } else {
                $upload_error = '圖片上傳失敗，請稍後再試。';
            }
        } else {
            $upload_error = '請上傳 PNG, JPG, JPEG 或 GIF 格式的圖片。';
        }
    } else if ($_FILES['ppic']['error'] !== UPLOAD_ERR_NO_FILE) {
        $upload_error = '圖片上傳發生錯誤。';
    }

    if (empty($upload_error)) {
        try {
            $stmt = $pdo->prepare("UPDATE products SET pname= :pname,pscrib= :pscrib, ppic= :ppic WHERE pno = :pno");
            $stmt->bindParam(':pname', $pname);
            $stmt->bindParam('pscrib', $pscrib);
            $stmt->bindParam('ppic', $ppic);
            $stmt->bindParam('pno', $pno, PDO::PARAM_INT);
            $stmt->execute();
            
            header("Location: home.php");//更新成功導回首頁
            exit;
        } catch (PDOException $e) {
            die("更新資料錯誤: " . $e->getMessage());
        }
    }
}
?>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>內門區景點與特有活動資料管理系統_修改景點活動</title>
    <link rel="stylesheet" href="mystyle.css">
    <script>
        function confirmUpdate() {
            if (confirm("確定要儲存修改嗎？")) {
                document.getElementById("updateForm").submit();
            } else {
                window.location.href = "home.php"; // 取消則返回首頁
            }
        }

        function cancelUpdate() {
            if (confirm("確定要取消修改作業嗎？")) {
                window.location.href = "home.php";
            }
        }
    </script>
</head>
<body>
    <div class="container">
       <center><h1><U>內門區景點與特有活動資料管理系統_修改景點活動</U></h1></center>
        <form id="updateForm" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="pno" value="<?php echo $product['pno']; ?>">
            <input type="hidden" name="old_ppic" value="<?php echo $product['ppic']; ?>">
            <div class="form-group">
                <label for="pname">景點活動名稱:</label>
                <input type="text" id="pname" name="pname" value="<?php echo $product['pname']; ?>" required>
            </div>
            <div class="form-group">
                <label for="pscrib">景點活動描述:</label>
                <textarea id="pscrib" name="pscrib" rows="4"><?php echo $product['pscrib']; ?></textarea>
            </div>
            <div class="form-group">
                <label for="ppic">景點活動圖片 (PNG, JPG, JPEG, GIF):</label>
                <?php if (!empty($product['ppic'])): ?>
                    <div>
                        <img src="imgs/<?php echo $product['ppic']; ?>" alt="<?php echo $product['ppic']; ?>" style="max-width: 100px; max-height: 100px;">
                        <p>目前圖片：<?php echo $product['ppic']; ?></p>
                    </div>
                <?php endif; ?>
                <input type="file" id="ppic" name="ppic">
                <?php if ($upload_error): ?>
                    <div class="alert alert-danger"><?php echo $upload_error; ?></div>
                <?php endif; ?>
            </div>
            <button type="button" class="button" onclick="confirmUpdate()">確定存檔</button>
            <button type="button" class="button cancel-button" onclick="cancelUpdate()">取消作業</button>
        </form>
    </div>
</body>
</html>