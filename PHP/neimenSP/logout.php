<?php
session_start();

// 清除所有 Session 變數
$_SESSION = array();

// 如果設定了 cookie，也將其清除
if (ini_get("session.use_cookies")) {
    $params = session_get_cookie_params();
    setcookie(session_name(), '', time() - 42000,
        $params["path"], $params["domain"],
        $params["secure"], $params["httponly"]
    );
}

// 最後，銷毀 session
session_destroy();

// 導向回登入頁面
header("Location: login.php");
exit;
?>
