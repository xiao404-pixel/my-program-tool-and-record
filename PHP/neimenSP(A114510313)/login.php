<?php
session_start(); // 啟用 Session

// 檢查是否已登入，若已登入則導向首頁
if (isset($_SESSION['username'])) {
    header("Location: home.php");
    exit;
}

require_once 'db_config.php'; // 引入資料庫連線設定

$login_error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'];
    $password = $_POST['password'];

    if (!empty($username) && !empty($password)) {
        try {
            $stmt = $pdo->prepare("SELECT * FROM users WHERE username = :username");
            $stmt->bindParam(':username', $username);
            $stmt->execute();
            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($user && $user['pwd'] === $password) {
                // 登入成功，設定 Session
                $_SESSION['username'] = $username;
                header("Location: home.php");
                exit;
            } else {
                $login_error = '帳號或密碼錯誤';
            }
        } catch (PDOException $e) {
            die("查詢錯誤: " . $e->getMessage());
        }
    } else {
        $login_error = '請輸入帳號和密碼';
    }
}
?>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登入</title>
    <link rel="stylesheet" href="mystyle.css">
</head>
<body>
    <div class="container">
        <h1>會員登入</h1>
        <?php if ($login_error): ?>
            <div class="alert alert-danger"><?php echo $login_error; ?></div>
        <?php endif; ?>
        <form method="POST">
            <div class="form-group">
                <label for="username">帳號:</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password">密碼:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit" class="button">登入</button>
        </form>
    </div>
</body>
</html>
