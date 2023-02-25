<?php
// データベースへの接続に必要な変数を指定
$host = 'localhost';
$username = 'root';
$passwd = '';
$dbname = 'img_db';
 
// データベースへ接続
$db = mysqli_connect($host, $username, $passwd, $dbname);
 
// 接続チェック
if (!$db) {
  die('データベースの接続に失敗しました。');
}
 
echo "データベースの接続に成功しました！ \n";
 
// データベースの接続を閉じる
mysqli_close($db);
?>
