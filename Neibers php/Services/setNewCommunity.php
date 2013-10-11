<?php
    
    //if(isset($_POST['accessToken']) && isset($_POST['type']) && isset($_POST['name']) && isset($_POST['address'])&& isset($_POST['Description']) && isset($_POST['link']) &&
    //                 isset($_POST['openCloseCommunity'])&& isset($_POST['lat']) && isset($_POST['long'])){
    
    $accessToken=''.$_POST['accessToken'];
    $type=''.$_POST['type'];
    $numberType=''.$_POST['numberType'];
    $name=''.$_POST['name'];
    $address=''.$_POST['address'];
    $Description=''.$_POST['Description'];
    $link=''.$_POST['link'];
    $openCloseCommunity=''.$_POST['openCloseCommunity'];
    $lat=''.$_POST['lat'];
    $long=''.$_POST['lon'];
    $file=$_FILES['ImageFile'];
    //$target_path = 'images/' . basename( $_FILES['ImageFile']['name']);
    require_once 'config.php';
    $db = mysql_connect(DB_HOST, DB_USER, DB_PASSWORD) or die("Connection Error: " . mysql_error());
    mysql_select_db(DB_DATABASE);;
    mysql_set_charset('utf8', $db);
    
    
    
    
    
    
    
    //               $resultId=  mysql_fetch_array($myId,MYSQL_ASSOC);
    //               $target_path = '';
    //               move_uploaded_file($_FILES["ImageFile"]["tmp_name"],$target_path);
    
    //    (ID,accessToken,type,name,address,Description,link
    //     ,openCloseCommunity,lat,long,image_path)
    
    $insert=  mysql_query("INSERT INTO communities     (ID,type,numberType,name,address,Description,link,openCloseCommunity,lat,lon,imageFile,accessToken) VALUES('DEFAULT','$type','$numberType','$name','$address','$Description','$link','$openCloseCommunity','$lat','$long','$target_path','$accessToken')");
    
    if($insert){
        $myId= mysql_query("SELECT ID FROM communities WHERE accessToken='$accessToken' AND name='$name' AND lat='$lat' AND lon='$long' AND type='$type'",$db);
        if($myId){
            $resultId=  mysql_fetch_array($myId,MYSQL_ASSOC);
            $target_path = 'images/communities/'.$resultId['ID'].'.jpg';
            mysql_query("UPDATE communities SET imageFile='$target_path' WHERE accessToken='$accessToken' AND name='$name' AND lat='$lat' AND lon='$long' AND type='$type'", $db);
            move_uploaded_file($_FILES["ImageFile"]["tmp_name"],$target_path);
            echo 'OK';
        }
    } else {
        echo 'Error';
    }
    //}  else {
    //    echo 'Missing parameters';
    //}
    
    
    
    mysql_close($db);
    function preventSqlInjection($input){
        return mysql_real_escape_string($input);
    }
    
    
    
    
    
    ?>
