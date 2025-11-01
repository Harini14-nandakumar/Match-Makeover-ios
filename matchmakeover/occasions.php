<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');

$host = "localhost";
$dbname = "matchmakeover";
$username = "root";
$password = "";

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die(json_encode(["status" => "error", "message" => "Database connection failed: " . $e->getMessage()]));
}

// Handle GET request - Fetch all occasions or filter by category
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    try {
        // Check if category filter is provided
        if (isset($_GET['category']) && !empty(trim($_GET['category']))) {
            $category = trim($_GET['category']);
            $stmt = $pdo->prepare("SELECT id, name, image, image2, gender, color, category FROM occasions WHERE category = :category");
            $stmt->execute(['category' => $category]);
        } else {
            $stmt = $pdo->query("SELECT id, name, image, image2, gender, color, category FROM occasions");
        }
        
        $occasions = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($occasions);
        exit;
    } catch (PDOException $e) {
        die(json_encode(["status" => "error", "message" => "Failed to fetch occasions: " . $e->getMessage()]));
    }
}

// Handle POST request - Add new occasion (same as new_occasion.php)
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (
        isset($_POST['occasion_name'], $_POST['gender'], $_POST['color'], $_POST['category']) &&
        !empty(trim($_POST['occasion_name'])) &&
        !empty(trim($_POST['gender'])) &&
        !empty(trim($_POST['color'])) &&
        !empty(trim($_POST['category']))
    ) {
        $occasionName = trim($_POST['occasion_name']);
        $gender = trim($_POST['gender']);
        $color = trim($_POST['color']);
        $category = trim($_POST['category']);
        $imageDirectory = 'uploads/occasions/';

        if (!file_exists($imageDirectory)) {
            mkdir($imageDirectory, 0777, true);
        }

        $imagePath1 = null;
        $imagePath2 = null;

        // Top image
        if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
            $imageName1 = str_replace(' ', '_', $_FILES['image']['name']);
            $imageTmpName1 = $_FILES['image']['tmp_name'];
            $imagePath1 = $imageDirectory . basename($imageName1);
            if (!move_uploaded_file($imageTmpName1, $imagePath1)) {
                echo json_encode(["status" => "error", "message" => "Failed to upload top image"]);
                exit;
            }
        }

        // Bottom image
        if (isset($_FILES['image2']) && $_FILES['image2']['error'] === UPLOAD_ERR_OK) {
            $imageName2 = str_replace(' ', '_', $_FILES['image2']['name']);
            $imageTmpName2 = $_FILES['image2']['tmp_name'];
            $imagePath2 = $imageDirectory . basename($imageName2);
            if (!move_uploaded_file($imageTmpName2, $imagePath2)) {
                echo json_encode(["status" => "error", "message" => "Failed to upload bottom image"]);
                exit;
            }
        }

        try {
            // Check if occasion exists
            $stmt = $pdo->prepare("SELECT COUNT(*) FROM occasions WHERE name = :name AND gender = :gender AND color = :color AND category = :category");
            $stmt->execute([
                'name' => $occasionName, 
                'gender' => $gender, 
                'color' => $color,
                'category' => $category
            ]);
            $count = $stmt->fetchColumn();

            if ($count > 0) {
                echo json_encode(["status" => "error", "message" => "Occasion already exists for this gender, color and category"]);
                exit;
            }

            // Insert with category
            $stmt = $pdo->prepare("INSERT INTO occasions (name, image, image2, gender, color, category) VALUES (:name, :image, :image2, :gender, :color, :category)");
            $stmt->execute([
                'name' => $occasionName,
                'image' => $imagePath1,
                'image2' => $imagePath2,
                'gender' => $gender,
                'color' => $color,
                'category' => $category
            ]);

            echo json_encode([
                "status" => "success",
                "message" => "Occasion added successfully",
                "data" => [
                    "name" => $occasionName,
                    "image" => $imagePath1,
                    "image2" => $imagePath2,
                    "gender" => $gender,
                    "color" => $color,
                    "category" => $category
                ]
            ]);
        } catch (PDOException $e) {
            echo json_encode(["status" => "error", "message" => "Failed to add occasion: " . $e->getMessage()]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Invalid occasion name, gender, color or category"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}
?>