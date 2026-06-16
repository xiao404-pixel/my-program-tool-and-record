<?php
session_start();

// 檢查是否已登入，若未登入則導向登入頁面
if (!isset($_SESSION['username'])) {
    header("Location: login.php");
    exit;
}

require_once 'db_config.php'; // 引入資料庫連線設定
//列表資料的相關程式
$page = isset($_GET['page']) ? intval($_GET['page']) : 1; // 取得目前頁數，預設為第一頁
$items_per_page = 3; // 每頁顯示的產品數量
$offset = ($page - 1) * $items_per_page;
try {
    // 取得總產品數量
    $total_stmt = $pdo->query("SELECT COUNT(*) FROM products");
    $total_products = $total_stmt->fetchColumn();
    $total_pages = ceil($total_products / $items_per_page);
    // 取得當前頁面的產品資料
    $stmt = $pdo->prepare("SELECT pno, pname, pptime, pscrib, ppic, pmap_link FROM products LIMIT :offset, :limit");
    $stmt->bindParam(':offset', $offset, PDO::PARAM_INT);
    $stmt->bindParam(':limit', $items_per_page, PDO::PARAM_INT);
    $stmt->execute();
    $products = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    die("查詢錯誤: " . $e->getMessage());
}

?>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>首頁</title>
    <link rel="stylesheet" href="mystyle.css">
</head>
<body>
    <div class="container">
        <h1>內門區景點與特有活動資料管理系統_首頁</h1>
        <div class="user-nav">
            <p>歡迎，<?php echo $_SESSION['username']; ?>！</p>
            <a href="logout.php" class="button">登出</a>
        </p>
    </div>

    <div class="table-responsive">
        <table>
            <thead>
                <tr><th>景點活動編號</th><th>景點活動名稱</th><th>景點活動時間</th><th>景點活動詳細描述</th><th>景點活動圖片</th><th>地圖導航連結</th><th>操作</th>
            </thead>
            <tbody>
                <?php if(count($products)>0): ?>
                    <?php
                    $counter = $offset + 1;
                    foreach ($products as $product): ?>
                        <tr>
                            <td><?php echo $counter++; //景點活動編號 ?></td>
                            <td><?php echo $product['pname']; //景點活動名稱 ?></td>
                            <td><?php echo $product['pptime']; //景點活動時間 ?></td>
                            <td><?php echo $product['pscrib']; //景點活動詳細描述 ?></td>
                            <td><img src="imgs/<?php echo $product['ppic']; //景點活動圖片 ?>" alt="<?php echo $product['pname']; ?>"></td>
                            <td>
                                <?php if (!empty($product['pmap_link'])): ?>
                                    <a href="<?php echo $product['pmap_link']; ?>" target="_blank" class="button">查看地圖</a>
                                <?php else: ?>
                                    <span style="color: #999;">無</span>
                                <?php endif; ?>
                            </td>
                            <td>
                                <a href="delete.php?pno=<?php echo $product['pno']; ?>" class="button cancel-button">刪除</a>
                                <a href="update.php?pno=<?php echo $product['pno']; ?>" class="button">修改</a>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                <?php else: ?>
                    <tr><td colspan="6">尚無任何景點活動資料.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>

        <div class="pagination">
            <a href="home.php">首頁</a>
            <a href="add.php">新增</a>
            <?php if ($total_pages > 1): ?>
                <?php if ($page > 1): ?>
                    <a href="home.php?page=<?php echo ($page -1); ?>">上一頁</a>
                <?php endif; ?>
                <?php for ($i=1; $i <= $total_pages; $i++): ?>
                    <a href="home.php?page=<?php echo $i; ?>" class="<?php echo ($i === $page) ? 'current-page' : ''; ?>"> <?php echo $i; ?></a>
                <?php endfor; ?>
                <?php if ($page < $total_pages): ?>
                    <a href="home.php?page=<?php echo ($page +1); ?>">下一頁</a>
                <?php endif; ?>
                <a href="home.php?page=<?php echo $total_pages; ?>">最後一頁</a>
            <?php endif; ?>    
        </div>  
    </div>
</body>
</html>
