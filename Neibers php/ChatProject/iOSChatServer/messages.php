<?php
//header( 'Content-type: text/xml' );
$db = mysql_connect('localhost','neiberso', 'Avi1234') or die("Connection Error: " . mysql_error());    
// select the database
mysql_select_db('neiberso_test',$db) or die("Error connecting to db.");
if ( $_REQUEST['past'] ) {
	$result = mysql_query('SELECT * FROM chatitems WHERE id > '.
		mysql_real_escape_string( $_REQUEST['past'] ).
		' ORDER BY added LIMIT 50');
} else {
	$result = mysql_query('SELECT * FROM chatitems ORDER BY added LIMIT 50' );	
}

?>
<?php
$userDetails= array();
while ($row = mysql_fetch_assoc($result)) {
    $userDetails[] = $row;
}
$json = json_encode(array('chat' => $userDetails));
echo $json;
?>
