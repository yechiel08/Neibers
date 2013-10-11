<?php
    $db = mysql_connect('localhost','neiberso', 'Avi1234') or die("Connection Error: " . mysql_error());
    
    // select the database
    mysql_select_db('neiberso_test',$db) or die("Error connecting to db.");
    mysql_set_charset('utf8', $db);

    if(!isset($_POST['accessToken'])||!isset($_POST['newPassword'])||!isset($_POST['oldPassword'])){
//        echo 'one of the parameters is missing';
        $newPass=''.$_GET['newPassword'];
        $accessToken=''.$_GET['accessToken'];
        $oldPass=''.$_GET['oldPassword'];
        
        $myOldPassword=  mysql_query("SELECT password FROM users WHERE access_token='$accessToken'", $db);
        $res_OldPassword=  mysql_fetch_array($myOldPassword, MYSQL_ASSOC);
        $res_OldPassword=$res_OldPassword['password'];
        
        if($res_OldPassword == $oldPass){
            $res = mysql_query("UPDATE users SET password='$newPass' WHERE access_token='$accessToken'",$db);
            if($res){
                $subject = "Your password has been changed";
                $message = "Your password has been changed"."\r\n".
                "your new password is:".$newPass;
                $from = "support@neibers.org";
                $headers = "From:" . $from;
                mail($mail,$subject,$message,$headers);
                echo 'OK';
            }else {
                echo 'Error';
            }
        }else {
            echo 'Not Equal';
        }
    }else{
        echo 'Yechiel';

        $newPass=''.$_POST['newPassword'];
        $accessToken=''.$_POST['accessToken'];
        $oldPass=''.$_POST['oldPassword'];
        $myOldPassword=  mysql_query("SELECT password FROM users WHERE access_token='$accessToken'", $db);
        $res_OldPassword=  mysql_fetch_array($myOldPassword, MYSQL_ASSOC);
        echo $res_OldPassword;
        
        if($res_OldPassword == $oldPass){
            $res = mysql_query("UPDATE users SET password='$newPass' WHERE access_token='$accessToken'",$db);
            if($res){
                $subject = "Your password has been changed";
                $message = "Your password has been changed"."\r\n".
                "your new password is:".$newPass;
                $from = "support@neibers.org";
                $headers = "From:" . $from;
                mail($mail,$subject,$message,$headers);
                echo 'OK';
            }else {
                echo 'Error';
            }
        }else {
            echo 'Error';
        }
    }
    if( isset($_POST['accessToken']) && isset($_POST['newPassword']) && isset($_POST['oldPassword'])){

    }else {
        
    }
    mysql_close($db);
    ?>
