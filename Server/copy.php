<!DOCTYPE html>
<html>
<head>
 <title>PHPサンプル</title>
</head>
<body>
<?php
shell_exec('cd htdocs');
$timestamp = time();
mkdir('log/'.$timestamp, 0777);
chmod('log/'.$timestamp, 0777);
$flg = copy('jsons/path.txt', 'log/path'.$timestamp.'.txt');
if ($flg) {
    echo "コピー成功です";
} else {
    echo "コピー失敗です";
}
$copy1 = copy_dir('DetectImages','log/'.$timestamp);
$copy2 = copy_dir('images','log/'.$timestamp);

if ($copy1) {
    echo "コピー1成功です<br/>\n";
} else {
    echo "コピー1失敗です<br/>\n";
}
if ($copy2) {
    echo "コピー2成功です<br/>\n";
} else {
    echo "コピー2失敗です<br/>\n";
}


function copy_dir($dir, $new_dir)
{
    $dir     = rtrim($dir, '/').'/';
    $new_dir = rtrim($new_dir, '/').'/';

    // コピー元ディレクトリが存在すればコピーを行う
    if (is_dir($dir)) {
        // コピー先ディレクトリが存在しなければ作成する
        if (!is_dir($new_dir)) {
            mkdir($new_dir, DIR_WRITE_MODE);
            chmod($new_dir, DIR_WRITE_MODE);
        }

        // ディレクトリを開く
        if ($handle = opendir($dir)) {
            // ディレクトリ内のファイルを取得する
            while (false !== ($file = readdir($handle))) {
                if ($file === '.' || $file === '..') {
                    continue;
                }
                // 下の階層にディレクトリが存在する場合は再帰処理を行う
                if (is_dir($dir.$file)) {
                    copy_dir($dir.$file, $new_dir.$file);
                } else {
                    copy($dir.$file, $new_dir.$file);
                }
            }
            closedir($handle);
            return true;
        }
    }
    else{
        return false;
    }
}
?>
</body>
</html>
