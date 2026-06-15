<?php
// 資料庫設定
$host = 'localhost'; // 您的 MySQL 主機名稱
$dbname = 'neimenspa';    // 您的資料庫名稱
$username = 'root'; // 您的 MySQL 使用者名稱
$password = ''; // 您的 MySQL 密碼

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("資料庫連線失敗: " . $e->getMessage());
}
?>

