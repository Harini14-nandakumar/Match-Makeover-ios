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

// Handle GET request
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    try {
        // Fetch all genders from the database
        $stmt = $pdo->query("SELECT * FROM genders");
        $genders = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Return the fetched genders
        echo json_encode([
            "status" => "success",
            "message" => "Genders fetched successfully",
            "genders" => $genders
        ]);
    } catch (PDOException $e) {
        echo json_encode(["status" => "error", "message" => "Failed to fetch genders: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}
?>
