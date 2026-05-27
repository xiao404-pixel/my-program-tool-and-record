	<?php
		$Orderer = $transport_name = $order_notes = $gift = $addon_text = $product_name = "";
		$total = 0;
		
		if (empty($_GET['Orderer'])){
			$Orderer = "訂購人未填，請重新輸入";
		} else {
			$Orderer = $_GET['Orderer'];
		}

		$product_price = isset($_GET['product']) ? (int)$_GET['product'] : 0;
		$quantity = isset($_GET['quantity']) ? (int)$_GET['quantity'] : 1;

		switch ($product_price) {
			case 1000:
				$product_name = "MP5";
				break;
			case 3000:
				$product_name = "UMP45";
				break;
			case 5000:
				$product_name = "MP7";
				break;
			default:
				$product_name = "未選擇商品";
		}

		if (empty($_GET['transport'])) {
        	$shipping = 0;
        	$transport_name = "運送方式未選擇，請選擇運送方式";
    	} else {
        	$shipping = (int)$_GET['transport'];
        	$transport_name = ($shipping == 100) ? "海運(100元)" : "空運(200元)";
    	}

    	if (empty($_GET['order_notes'])) {
        	$order_notes = "無備註";
    	} else {
			$order_notes = $_GET['order_notes'];
		}

		if (isset($_GET['gift_box']) && $_GET['gift_box'] == "1") {
			$gift = "需要禮品盒(+50元)";
			$gift_fee = 50;
		} else {
			$gift = "不需要禮品盒";
			$gift_fee = 0;
		}

		$addon_total = 0;
		if (empty($_GET['ADD'])){
			$addon_text = "無加購";
		} else {
			foreach ($_GET['ADD'] as $price) {
				$addon_total += (int)$price;
				$addon_text .= "配件($$price) ";
			}
		}

		$total = $product_price * $quantity + $shipping + $gift_fee + $addon_total;

	?>

	<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>PHP表單資訊接收_GET接收</title>
</head>
<body>
	<center><h1>訂單明細</h1></center>
	<hr>
	<p>--------------------訂單明細如下----------------</p>
	1.訂購人:       		<?php echo $Orderer; ?> <BR>
	2.商品名稱:	<?php echo $product_name; ?> <BR>
	3.商品數量:	<?php echo $quantity; ?> <BR>
	4.運送方式:   		<?php echo $transport_name; ?> <BR>
	5.訂單備註:       	<?php echo $order_notes; ?> <BR>
	6.禮盒包裝:   	<?php echo $gift; ?> <BR>
	7.加購商品:	<?php echo $addon_text; ?> <BR>
	
	<hr>
	<h2 style="color: red;">總金額： $<?php echo $total; ?> 元</h2>
</body>
</html>