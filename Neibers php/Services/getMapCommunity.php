<?php
     require_once 'config.php';
 $db = mysql_connect(DB_HOST, DB_USER, DB_PASSWORD) or die("Connection Error: " . mysql_error()); 
    mysql_select_db(DB_DATABASE) or die("Error connecting to db."); 
mysql_set_charset('utf8', $db);

//$query= mysql_query("SELECT * FROM communities",$db);
//  $arr=array();
//  if($query){
//      while ($row=  mysql_fetch_array($query,MYSQL_ASSOC)){
//        $count=0;
//         $arr2['id']=$row['ID'];
//         $arr2['imagePath']=$row['imageFile'];
//          $arr2['type']=$row['type'];
//         $arr2['name']=$row['name'];
//          $arr2['address']=$row['address'];
//         $arr2['link']=$row['link'];
//           $arr2['lat']=$row['lat'];
//         $arr2['long']=$row['lon'];
//         $num=  intval($row['ID']);
//         $query2= mysql_query("SELECT COUNT(*) as count FROM community_members WHERE community_id=$num",$db);
//         if($query2){
//             $count=  mysql_fetch_array($query2,MYSQL_ASSOC);
//         }
//          $arr2['numberFriends']=$count['count'];
//          $arr[$row['ID']]=$arr2;
//          // be sure to put text data in CDATA
//      }
//  }
//  $arr3=array("getMapCommunity"=>$arr2);
//
//  echo json_encode($arr3);

$retrieve= mysql_query("SELECT * FROM communities",$db);
$userDetails= array();
while($row = mysql_fetch_assoc($retrieve)) {
    $count=0;
    $num=  intval($row['ID']);
    $query2= mysql_query("SELECT COUNT(*) as count FROM community_members WHERE community_id=$num",$db);
    if($query2){
        $count=  mysql_fetch_array($query2,MYSQL_ASSOC);
    }
    $row['numberFriends']=$count['count'];
    $userDetails[] = $row;
}   
$json = json_encode(array('getMapCommunity' => $userDetails));
echo $json;
?>
