<?php
    
    
    $secretKey="jdfy57yg4dgFGFGry533rtyhdfGTdfgdt345tythdFgdjkukiU";
    $width=''.$_POST['clientResolutionWidth'];
    $height=''.$_POST['clientResolutionHeight'];
    $device_type=''.$_POST['deviceTypeName'];
    $device_id=''.$_POST['DeviceID'];
    $system=''.$_POST['operatingSystem'];
    $device_token=''.$_POST['DeviceToken'];
    $name=''.$_POST['userFullName'];
    $email=''.$_POST['userEmail'];
    $signature=''.$_POST['signature'];
    $file=$_FILES['ImageFile'];
    //$target_path = 'images/' . basename( $_FILES['ImageFile']['name']);
    $db = mysql_connect('localhost','neiberso', 'Avi1234') or die("Connection Error: " . mysql_error());
    
    // select the database
    mysql_select_db('neiberso_test',$db) or die("Error connecting to db.");
    mysql_set_charset('utf8', $db);
    if(md5($secretKey.$email)==  $signature){
        
        //echo md5('asaf.tobi@gmai.com');
        
        // connect to the MySQL database server
        
        $emailAuten=mysql_query("SELECT COUNT(*) as count FROM users WHERE mail='$email'", $db);
        $emailRes=  mysql_fetch_array($emailAuten, MYSQL_ASSOC);
        $access_token= generateRandomString();
        
        if($emailRes['count']=='0'){
            
            $pass=  substr($access_token, strlen($access_token)-7);
            
            
            if(isset($_POST['DeviceToken']) && isset($_POST['userEmail'])
               && isset($_POST['userFullName'])){
                
                $insert=  mysql_query("INSERT INTO users (ID,name,mail,password,widthResolution,heightResolution,operatingSys
                                      ,device_id,device_token,DeviceTypeName,image_path,access_token) VALUES('DEFAULT','$name','$email','$pass','$width','$height','$system',
                                                                                                             '$device_id','$device_token','$device_type','$target_path','$access_token')");
                $myId= mysql_query("SELECT ID FROM users WHERE mail='$email' AND password='$pass'",$db);
                if($myId){
                    $resultId=  mysql_fetch_array($myId,MYSQL_ASSOC);
                    $target_path = 'images/user_profile/' ;//. basename( $_FILES['file']['name']);
                    
                    $target_path = $target_path.$resultId['ID'].'.jpg';
                    mysql_query("UPDATE users SET image_path='$target_path' WHERE mail='$email' AND password='$pass' ", $db);
                    move_uploaded_file($_FILES["ImageFile"]["tmp_name"],$target_path);
                    
                    
                    if($insert){
                        
                        $subject = "Your registration is complete";
                        $message = "Your registration is complete"."\r\n".
                        "your new password is:".$pass;
                        $from = "support@neibers.org";
                        $headers = "From:" . $from;
                        mail($email,$subject,$message,$headers);
                        
                        $arr=array("accessToken"=>$access_token,"password"=>$pass);
                        $arr2=array("authenticateUser"=>$arr);
                        
                        echo json_encode($arr2);
                    }
                }  else {
                    echo 'Error occured';
                }
            }  else {
                echo 'missing parameters';
            }
            
            
            
            
        }  else {
            echo 'This email is already exist';
            //  mysql_query("UPDATE users SET access_token='$access_token' WHERE mail='$email' ", $db);
            
        }
        
        
    }  else {
        echo 'invalid signature';
    }
    mysql_close($db);
    
    
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
    function key_str($str){
        return substr($str, 0,50);
    }
    
    
    ?>
