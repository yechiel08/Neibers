<?php
$userEmail='';
if(isset($_POST['userEmail']))
    $userEmail=''.$_POST['userEmail'];
else if(isset ($_GET['userEmail']))
    $userEmail=$_GET['userEmail'];
else
    $userEmail='';
$db = mysql_connect('localhost','neiberso', 'Avi1234') or die("Connection Error: " . mysql_error()); 
 
// select the database 
mysql_select_db('neiberso_test',$db) or die("Error connecting to db."); 
mysql_set_charset('utf8', $db);
$res= mysql_query("SELECT COUNT(mail) as count,mail FROM users WHERE mail='$userEmail'", $db);
$count= mysql_fetch_array($res, MYSQL_ASSOC);
if($count['count']=='1'){
$to=$count['mail'];
$date = new DateTime();
$str=''.$date->getTimestamp();
$str=  substr($str,0,6);
$update=  mysql_query("UPDATE users set password='$str' WHERE mail='$userEmail'", $db);
if($update){
$subject = "Your password has been changed";
$message = "Your password has been changed to temporary password"."\r\n".
        "the new password is:".$str;
$from = "support@neibers.org";
$headers = "From:" . $from;
mail($to,$subject,$message,$headers);
echo "OK";
}
}
else{
    echo 'Not Exist';
}
mysql_close($db);
?>
