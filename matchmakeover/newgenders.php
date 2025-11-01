<?php
// Database configuration
$host = "localhost";
$dbname = "matchmakeover";
$username = "root";
$password = "";

// Connect to the database
try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die(json_encode(["status" => "error", "message" => "Database connection failed: " . $e->getMessage()]));
}

// Handle POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get the gender name from the request body
    $data = json_decode(file_get_contents('php://input'), true);

    if (isset($data['gender_name']) && !empty(trim($data['gender_name']))) {
        $genderName = trim($data['gender_name']);

        try {
            // Check if the gender already exists
            $stmt = $pdo->prepare("SELECT COUNT(*) FROM genders WHERE name = :name");
            $stmt->execute(['name' => $genderName]);
            $count = $stmt->fetchColumn();

            if ($count > 0) {
                echo json_encode(["status" => "error", "message" => "Gender already exists"]);
                exit;
            }

            // Insert the new gender
            $stmt = $pdo->prepare("INSERT INTO genders (name) VALUES (:name)");
            $stmt->execute(['name' => $genderName]);

            echo json_encode(["status" => "success", "message" => "Gender added successfully"]);
        } catch (PDOException $e) {
            echo json_encode(["status" => "error", "message" => "Failed to add gender: " . $e->getMessage()]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Invalid gender name"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}
?>
