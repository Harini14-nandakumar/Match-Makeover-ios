<?php
$host = "localhost";  // Your database host
$dbname = "matchmakeover";  // Your database name  
$username = "root";  // Your database username
$password = "";  // Your database password

// Create a connection to the MySQL database
$conn = new mysqli($host, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>


