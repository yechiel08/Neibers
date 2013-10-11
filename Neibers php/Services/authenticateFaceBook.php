<?php

$secretString=''.$_POST['signature'];
$width=''.$_POST['clientResolutionWidth'];
$height=''.$_POST['clientResolutionHeight'];
$device_type=''.$_POST['deviceTypeName'];
$device_id=''.$_POST['DeviceID'];
$system=''.$_POST['operatingSystem'];
$device_token=''.$_POST['DeviceToken'];
$name=''.$_POST['userFullName'];
$email=''.$_POST['userEmail'];
$pass=''.$_POST['userPassword'];
$facebook=''.$_POST['FaceBookId'];
$file=$_FILES['ImageFile'];
 $target_path = 'images' . basename( $_FILES['file']['name']);
move_uploaded_file($_FILES["file"]["tmp_name"],$target_path);
//echo md5('asaf.tobi@gmai.com');

// connect to the MySQL database server 
$db = mysql_connect('localhost','neiberso', 'Avi1234') or die("Connection Error: " . mysql_error()); 
 
// select the database 
mysql_select_db('neiberso_test',$db) or die("Error connecting to db."); 
mysql_set_charset('utf8', $db);
$emailAuten=mysql_query('SELECT COUNT(*) as count FROM users', $db);
$emailRes=  mysql_fetch_array($emailAuten, MYSQL_ASSOC);
if($emailRes['count']=='0'){
$access_token=  base64_encode($name.$email);
if(isset($_POST['signature']) && isset($_POST['DeviceToken']) && isset($_POST['userEmail']) 
        && isset($_POST['userPassword'])  && isset($_POST['userFullName'])){
   
 $insert=  mysql_query("INSERT INTO users (ID,name,mail,password,signature,widthResolution,heightResolution,operatingSys
     ,device_id,device_token,DeviceTypeName,image_path,faceBookId,access_token) VALUES(DEFAULT,'$secretString','$width','$height','$system',
     '$device_id','$device_token','$device_type','$name','$email','$pass','$target_path',$facebook,'$access_token')");
        }
}  else {
    echo 'this mail is already exist';    
}
// calculate the number of rows for the query. We need this for paging the result 
/*$result = mysql_query("SELECT access_token FROM users WHERE signature='$secretString' AND 
        widthResolution='$width' AND heightResolution='$height' AND operatingSys='$system' AND
        device_id='$device_id' AND device_token='$device_token' AND DeviceTypeName='$device_type'
        AND name='$name' AND mail='$email' AND password='$pass'"); 
$row = mysql_fetch_array($result,MYSQL_ASSOC); */
 
 
mysql_close($db);

 




?>

