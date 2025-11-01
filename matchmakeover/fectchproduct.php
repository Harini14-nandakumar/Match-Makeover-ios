<?php
header("Content-Type: application/json");

// Database connection
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "matchmakeover";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Database connection failed"]));
}

// Get filters from GET request
$genderid = isset($_GET['genderid']) ? $_GET['genderid'] : null;
$categoriesid = isset($_GET['categoriesid']) ? $_GET['categoriesid'] : null;
$occasionsid = isset($_GET['occasionsid']) ? $_GET['occasionsid'] : null;
$coloursid = isset($_GET['coloursid']) ? $_GET['coloursid'] : null;

// Build SQL query dynamically
$query = "SELECT * FROM product WHERE 1=1";
$params = [];
$types = "";

if ($genderid) {
    $query .= " AND genderid = ?";
    $params[] = $genderid;
    $types .= "i";
}
if ($categoriesid) {
    $query .= " AND categoriesid = ?";
    $params[] = $categoriesid;
    $types .= "i";
}
if ($occasionsid) {
    $query .= " AND occasionsid = ?";
    $params[] = $occasionsid;
    $types .= "i";
}
if ($coloursid) {
    $query .= " AND coloursid = ?";
    $params[] = $coloursid;
    $types .= "i";
}

$stmt = $conn->prepare($query);

if ($params) {
    $stmt->bind_param($types, ...$params);
}

$stmt->execute();
$result = $stmt->get_result();

$products = [];

while ($row = $result->fetch_assoc()) {
    $row['images'] = json_decode($row['images']); // Convert JSON string back to array
    $products[] = $row;
}

// Return response
echo json_encode(["status" => "success", "products" => $products]);

$stmt->close();
$conn->close();
?>
