<?php
header( 'Content-type: text/xml' );
$db = mysql_connect('localhost','neiberso', 'Avi1234') or die("Connection Error: " . mysql_error());
    
    // select the database
    mysql_select_db('neiberso_test',$db) or die("Error connecting to db.");
mysql_query( "INSERT INTO chatitems VALUES ( null, null, '".
	mysql_real_escape_string( $_REQUEST['user'] ).
	"', '".
	mysql_real_escape_string( $_REQUEST['message'] ).
	"')" );
?>
<success />
