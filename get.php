<?php

$mysqli = new mysqli("mysqlstudent", "arnvanhoutphosa9", "liib6eex1JoK", "arnvanhoutphosa9"); 

if ($result = $mysqli->query("SELECT Id, Name, Score FROM NewMedia")) { 
 
    $res = array(); 
    while ($row = $result->fetch_assoc()) 
    	$res[] = $row; 
 
    $result->close(); 
 
    header("Content-Type: application/json"); 
	header('Access-Control-Allow-Origin: *');
    echo json_encode($res); 
}
$mysqli->close(); 
?>