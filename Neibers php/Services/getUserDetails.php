<?php
    $db = mysql_connect('localhost','neiberso', 'Avi1234') or die("Connection Error: " . mysql_error());
    
    // select the database
    mysql_select_db('neiberso_test',$db) or die("Error connecting to db.");
    if(isset($_POST['accessToken']))
    $token=$_POST['accessToken'];
    else {
        $token=$_GET['accessToken'];
    }
    $result=mysql_query("SELECT * FROM users where access_token='$token'");
    $arr;
    
    // be sure to put text data in CDATA
    while($row = mysql_fetch_array($result,MYSQL_ASSOC)) {
        $arr=array( 'name'=>$row['name'], 'mail'=>$row['mail'],'image_path'=>$row['image_path']);
        $arr2=array("getUserDetails"=>$arr);
    }
    echo json_encode($arr2);
    mysql_close($db);
?>
