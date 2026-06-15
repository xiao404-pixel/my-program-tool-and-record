<?php
session_start();

// 檢查是否已登入，若未登入則導向登入頁面
if (!isset($_SESSION['username'])) {
    header("Location: login.php");
    exit;
}

require_once 'db_config.php'; // 引入資料庫連線設定

$upload_error = '';
$success_message = '';

//.... if for $_POSTs.....
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $pname = $_POST['pname'];
    //$pptime = $_POST['pptime'];
    $pscrib = $_POST['pscrib'];

    // 處理圖片上傳
    $ppic = '';
    if (isset($_FILES['ppic']) && $_FILES['ppic']['error'] === UPLOAD_ERR_OK) {
        $allowed_types = ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'];
        if (in_array($_FILES['ppic']['type'], $allowed_types)) {
            $upload_dir = 'imgs/';
            $file_extension = pathinfo($_FILES['ppic']['name'], PATHINFO_EXTENSION);
            $new_filename = uniqid() . '.' . $file_extension; // 產生唯一檔名
            $upload_path = $upload_dir . $new_filename;

            if (move_uploaded_file($_FILES['ppic']['tmp_name'], $upload_path)) {
                $ppic = $new_filename;
            } else {
                $upload_error = '圖片上傳失敗，請稍後再試。';
            }
        } else {
            $upload_error = '請上傳 PNG, JPG, JPEG 或 GIF 格式的圖片。';
        }
    } else if ($_FILES['ppic']['error'] !== UPLOAD_ERR_NO_FILE) {
        $upload_error = '圖片上傳發生錯誤。';
    }
//.... if for empty($upload_error)) => INSERT INTO.....
    if (empty($upload_error)){//檔案上傳正常
        try{
            $stmt = $pdo->prepare("INSERT INTO products (pname, pscrib, ppic) VALUES (:pname, :pscrib, :ppic)");
            $stmt->bindParam(":pname",$pname);//綁定資料參數
            $stmt->bindParam(":pscrib",$pscrib);
            $stmt->bindParam(":ppic",$ppic);
            $stmt->execute();//確定執行新增
            header("Location: home.php");//新增成功，返回首頁
            exit;
        } catch (PDOException $e){//儲存資料發生錯誤
            die("新增資料錯誤: ".$e->getMessage());
        }
    }
}
?>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>內門區景點與特有活動資料管理系統_新增景點活動</title>
    <link rel="stylesheet" href="mystyle.css">
    <script>
    //JS for confirm save new, or cancel
        function confirmSave(){//確認使用者所新增的資料要新增到資料庫
            if (confirm("您確定要儲存此筆景點資料嗎?")){
                document.getElementById("addForm").submit();//再次地確認
                } else {//不確定
                window.location.href = "home.php";//取消並轉回首頁
                }
            }
         function cancelAdd(){//確認取消[新增的資料]
            window.location.href = "home.php";//取消並轉回首頁
         }
    </script>
</head>
<body>
    <div class="container">
        <center><h1><U>內門區景點與特有活動資料管理系統_新增景點活動</U></h1></center>
        <form id="addForm" method="POST" enctype="multipart/form-data">
            <div class="form-group">
                <label for="pname">景點活動名稱:</label>
                <input type="text" id="pname" name="pname" required>
            </div>
            <div class="form-group">
                <label for="pscrib">景點活動詳細描述:</label>
                <textarea id="pscrib" name="pscrib" rows="4"></textarea>
            </div>
            <div class="form-group">
                <label for="ppic">景點活動圖片 (PNG, JPG, JPEG, GIF):</label>
                <input type="file" id="ppic" name="ppic">
                <?php if ($upload_error): ?>
                    <div class="alert alert-danger"><?php echo $upload_error; ?></div>
                <?php endif; ?>
            </div>
            <button type="button" class="button" onclick="confirmSave()">確定存檔</button>
            <button type="button" class="button cancel-button" onclick="cancelAdd()">取消作業</button>
        </form>
    </div>
</body>
</html>
