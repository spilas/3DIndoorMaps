<?php
 
$number = $_POST["number"];
$tap_x = (string) $_POST["tap_x"]+0;
$tap_y = (string) $_POST["tap_y"]+0;
 


shell_exec("cd htdocs");

$cmd="/home/dl-box/anaconda3/envs/yolo/bin/python maze.py ".$tap_x." ".$tap_y." ".$number;


shell_exec($cmd);

echo "マップが完成しました";
 
?>
