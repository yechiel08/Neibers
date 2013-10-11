<?php
// connect to the MySQL database server 
$db = mysql_connect('localhost','neiberso', 'Avi1234') or die("Connection Error: " . mysql_error()); 
 
// select the database 
mysql_select_db('neiberso_test',$db) or die("Error connecting to db."); 
$email=$_REQUEST['userEmail'];
$pass=$_REQUEST['userPassword'];

// calculate the number of rows for the query. We need this for paging the result 
$result = mysql_query("SELECT COUNT(*) as count FROM users WHERE mail='$email' AND password='$pass'");
$counter=0;
$token='';
$row = mysql_fetch_array($result,MYSQL_ASSOC);
if($row['count']=='1'){
    $access_token=  generateRandomString();
    mysql_query("UPDATE users SET access_token='$access_token' WHERE mail='$email' AND password='$pass'",$db);
}

mysql_close($db);


    echo $access_token;

function generateRandomString($length = 35) {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, strlen($characters) - 1)];
    }
       $date = new DateTime();
$str=''.$date->getTimestamp();
    return $randomString.$str;
}
?>
