<?php
shell_exec("cd htdocs");
$command="/home/dl-box/anaconda3/envs/yolo/bin/python exec_from_php.py 2>&1";

exec($command,$output);


print "$output[0]<br/>\n";
print "$output[1]<br/>\n";
print "$output[2]<br/>\n";


$page = "3";

$cmd="sudo /home/dl-box/anaconda3/envs/yolo/bin/python /home/dl-box/htdocs/detectpath.py map2 2>&1";

exec($cmd,$outputs);
print_r($outputs);

print "<br/>\n";
$user = exec('whoami');
$group = exec('groups ' .$user);
echo "ユーザー:{$user}<br>";
echo "グループ:{$group}<br>";

?>
