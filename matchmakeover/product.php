<?php
header("Content-Type: application/json");

// 🔗 Database connection
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "matchmakeover";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Database connection failed"]));
}

// ✅ Required POST fields
$genderid     = $_POST['genderid']     ?? null;
$categoriesid = $_POST['categoriesid'] ?? null;
$occasionsid  = $_POST['occasionsid']  ?? null;
$coloursid    = $_POST['coloursid']    ?? null;

// ❗ Validate fields
if (!$genderid || !$categoriesid || !$occasionsid || !$coloursid || empty($_FILES['images']['name'])) {
    echo json_encode(["status" => "error", "message" => "Missing required fields or images"]);
    exit();
}

// 📂 Upload directory
$uploadDirectory = "uploads/";
if (!is_dir($uploadDirectory)) {
    mkdir($uploadDirectory, 0777, true);
}

// 🖼️ Handle image uploads (top + bottom combo)
$imagePaths = [];

foreach ($_FILES['images']['tmp_name'] as $key => $tmp_name) {
    $imageName = basename($_FILES['images']['name'][$key]);
    $imagePath = $uploadDirectory . $imageName;

    // 🧠 Check valid image
    if (getimagesize($tmp_name)) {
        if (move_uploaded_file($tmp_name, $imagePath)) {
            $imagePaths[] = $imagePath;
        } else {
            echo json_encode(["status" => "error", "message" => "Error uploading: $imageName"]);
            exit();
        }
    } else {
        echo json_encode(["status" => "error", "message" => "$imageName is not a valid image"]);
        exit();
    }
}

// 📦 Convert image array to JSON
$imagePathsJson = json_encode($imagePaths);

// 📤 Insert into database
$stmt = $conn->prepare("
    INSERT INTO product (genderid, categoriesid, occasionsid, coloursid, images) 
    VALUES (?, ?, ?, ?, ?)
");
$stmt->bind_param("iiiss", $genderid, $categoriesid, $occasionsid, $coloursid, $imagePathsJson);

// ✅ Response
if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Product (top & bottom) added successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => "Database insert failed"]);
}

$stmt->close();
$conn->close();
?>
