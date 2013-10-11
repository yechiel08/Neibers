<?php
$db = mysql_connect('localhost','neiberso', 'Avi1234') or die("Connection Error: " . mysql_error()); 
 
// select the database 
mysql_select_db('neiberso_test',$db) or die("Error connecting to db."); 
mysql_set_charset('utf8', $db);
if(!isset($_POST['accessToken'])||!isset($_POST['userFullName'])||!isset($_POST['userEmail'])||!isset($_FILES['ImageFile'])){
            echo 'one of the parameters is missing';
        }else{
$accessToken=''.$_POST['accessToken'];
$name=''.$_POST['userFullName'];
$email=''.$_POST['userEmail'];
/*$pass=''.$_POST['userPassword'];*/
$file=$_FILES['ImageFile'];
 $target_path = 'images/user_profile/' ;//. basename( $_FILES['file']['name']);
 $myId=  mysql_query("SELECT ID FROM users WHERE access_token='$accessToken'", $db);
 if($myId){
     $res_id=  mysql_fetch_array($myId, MYSQL_ASSOC);
        $target_path=$target_path.$res_id['ID'].'.jpg';
$res=  mysql_query("UPDATE users SET mail='$email',name='$name',image_path='$target_path' WHERE access_token='$accessToken' ", $db);//,password='$pass'

    //mail='$email' AND password='$pass'
   
        
move_uploaded_file($_FILES["ImageFile"]["tmp_name"],$target_path);
        echo 'OK';

  
}
        }
        mysql_close($db);
?>
