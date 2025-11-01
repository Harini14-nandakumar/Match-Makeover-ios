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
    // Get the colour name from the request body
    $data = json_decode(file_get_contents('php://input'), true);

    if (isset($data['colour_name']) && !empty(trim($data['colour_name']))) {
        $colourName = trim($data['colour_name']);

        try {
            // Check if the colour already exists
            $stmt = $pdo->prepare("SELECT COUNT(*) FROM colours WHERE name = :name");
            $stmt->execute(['name' => $colourName]);
            $count = $stmt->fetchColumn();

            if ($count > 0) {
                echo json_encode(["status" => "error", "message" => "Colour already exists"]);
                exit;
            }

            // Insert the new colour
            $stmt = $pdo->prepare("INSERT INTO colours (name) VALUES (:name)");
            $stmt->execute(['name' => $colourName]);

            echo json_encode(["status" => "success", "message" => "Colour added successfully"]);
        } catch (PDOException $e) {
            echo json_encode(["status" => "error", "message" => "Failed to add colour: " . $e->getMessage()]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Invalid colour name"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}
?>
