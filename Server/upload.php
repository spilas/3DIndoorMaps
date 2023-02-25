<?php
 
$picture = $_POST["imageStr"];
$page = (string)$_POST["number"];
$folder_path = "images/" . "map" . $page . ".png";
 
$data = str_replace('data:image/png;base64,', '', $picture);
$data = str_replace(' ', '+', $data);
$data = base64_decode($data);
file_put_contents($folder_path, $data);
 
$host = 'localhost';
$username = 'root';
$passwd = '';
$dbname = 'img_db';

$conn = mysqli_connect($host, $username, $passwd, $dbname);
 
$sql = "INSERT INTO images (path) VALUES ('$folder_path')";
mysqli_query($conn, $sql);



#echo "Image has been uploaded";

//shell_exec("cd htdocs > /dev/null");

$cmd="sudo /home/dl-box/anaconda3/envs/yolo/bin/python detectpath.py map". $page ." > /dev/null &";

shell_exec($cmd);

if ($page == "3"){
    //txtファイル消去
    $deleted_list  = delete_allfile("runs/detect/exp/labels");
    $deleted_list  = delete_allfile("runs/detect/here/labels");
    sleep(3);

    $cmd2="sudo /home/dl-box/anaconda3/envs/yolo/bin/python detect.py --source images/ --conf 0.5 --weights best.pt --save-txt --exist-ok";
    shell_exec($cmd2);
    $cmd3="sudo /home/dl-box/anaconda3/envs/yolo/bin/python detect.py --source images/map1.png --conf 0.3 --weights here.pt --save-txt --exist-ok --name here";
    shell_exec($cmd3);
    echo "All images has been uploaded";
}

function delete_allfile($dirpath=''){
    if ( strcmp($dirpath,'')==0 ){ die('delete_allfile : error : please set dir_name'); }
    $deleted_list = array();
    $dir = dir($dirpath);
    while ( ($file=$dir->read()) !== FALSE ){
        if (preg_match('/^\./',$file)){ continue; }    // skip dir , skip hidden file
        else {
            array_push($deleted_list, $file);
            if ( ! unlink("$dirpath/$file") ){ die("delete_allfile : error : can not delete file [{$dirpath}/{$file}]"); }
        }
    }
    return $deleted_list;
}
 
?>
