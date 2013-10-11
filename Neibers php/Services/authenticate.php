<?php
if(isset($_POST['userEmail']))
$email=$_POST['userEmail'];
else
  $email=$_GET['userEmail'];  
$db = mysql_connect('localhost','neiberso', 'Avi1234') or die("Connection Error: " . mysql_error()); 
 
// select the database 
mysql_select_db('neiberso_test',$db) or die("Error connecting to db."); 
$result=  mysql_query("SELECT COUNT(*) as count FROM users WHERE email='$email' ");
$row = mysql_fetch_array($result,MYSQL_ASSOC); 
mysql_close($db);
if($row['count']=='1')
    echo true;
else {
    echo false;  
}
?>
