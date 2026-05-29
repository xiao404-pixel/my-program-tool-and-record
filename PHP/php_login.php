<!DOCTYPE html>
<?php
	session_start();
	if (!isset($_SESSION['membername']) || ($_SESSION['membername'])=="") {//SESSION不存在=未登入
		if(isset($_POST['username']) && isset($_POST['passwd'])){//確定使用者有輸入帳號密碼
			$username = 'admin';//預設帳號
			$passwd = '1234';//預設密碼
			if (($_POST['username'] == $username) && ($_POST['passwd'] == $passwd)){//登入的帳號與密碼正確=登入成功
				$_SESSION['membername'] = $username;//將登入帳號=>SESSION['membername']
	}
	header("Location: php_login.php");//重新引導去元網頁
		}
}
if(isset($_GET['logout']) && $_GET['logout']=="true"){//確定傳來[登出]的參數:logout=true
	unset($_SESSION['membername']);//刪除登入資訊
	header("Location: php_login.php");//重新引導去元網頁
}
?>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>PHP_登出登入_會員系統</title>
</head>
<body>
	<center><h1>PHP_登出登入_會員系統</h1></center>
	<hr>
	<?php
		if(isset($_SESSION['membername']) || ($_SESSION['membername']) ==""){//確認未登入，顯示未登入的網頁
	?>
	<form id="form1" name="form1" method="POST" action="php_login.php">
		<table width="300" border="0" align="center" cellspacing="0" cellpadding="5" bgcolor="#F2F2F2">
			<tr>
				<td colspan="2" align="center" valign="baseline" bgcolor="#CCC"><font color="#FFF">會員登入系統</font></td>
			</tr>
			<tr>
				<td width="30%" align="right" valign="baseline">帳號:</td>
				<td width="70%" align="left" valign="baseline"><input type="text" name="username" id="username"></td>
			</tr>
			<tr>
				<td width="30%" align="right" valign="baseline">密碼:</td>
				<td width="70%" align="left" valign="baseline"><input type="password" name="passwd" id="passwd"></td>
			</tr>
			<tr>
				<td colspan="2" align="center" valign="baseline" bgcolor="#CCC">
					<input type="submit" name="button" id="button" value="確定登入"><input type="reset" name="button2" id="button2" value="重新輸入"></td>
			</tr>
		</table>
	</form>
	<?php }	else{ //確認已登入，顯示已登入成功網頁並有[登出]按鈕?>
	<hr>
		<table width="300" border="0" align="center" cellspacing="0" cellpadding="5" bgcolor="#F2F2F2">
			<tr>
				<td align="center" valign="baseline" bgcolor="#CCC"><font color="#FFF">會員登入系統_登入成功</font></td>
			</tr>
			<tr>
				<td align="center" valign="baseline"><h3><U>您好!!! 恭喜您登入成功!!</U></h3></td>
			</tr>
			<tr>
				<td align="center" valign="baseline" bgcolor="#CCC"><a href="php_login.php?logout=true">登出本系統</a></td>
			</tr>
		</table>
	<?php } ?>
</body>
</html>