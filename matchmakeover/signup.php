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
    // Get user data from the request body
    $data = json_decode(file_get_contents('php://input'), true);

    // Validate input data
    if (
        isset($data['name'], $data['username'], $data['email'], $data['password'], $data['role']) &&
        !empty(trim($data['name'])) &&
        !empty(trim($data['username'])) &&
        filter_var($data['email'], FILTER_VALIDATE_EMAIL) &&
        !empty(trim($data['password'])) &&
        in_array($data['role'], ['user', 'admin'])
    ) {
        $name = trim($data['name']);
        $username = trim($data['username']);
        $email = trim($data['email']);
        $password = password_hash(trim($data['password']), PASSWORD_BCRYPT); // Hash the password
        $role = $data['role'];

        try {
            // Check if the username or email already exists
            $stmt = $pdo->prepare("SELECT COUNT(*) FROM signup WHERE username = :username OR email = :email");
            $stmt->execute(['username' => $username, 'email' => $email]);
            if ($stmt->fetchColumn() > 0) {
                echo json_encode(["status" => "error", "message" => "Username or email already exists"]);
                exit;
            }

            // Insert the user into the database
            $stmt = $pdo->prepare(
                "INSERT INTO signup (name, username, email, password, role) 
                 VALUES (:name, :username, :email, :password, :role)"
            );
            $stmt->execute([
                'name' => $name,
                'username' => $username,
                'email' => $email,
                'password' => $password,
                'role' => $role
            ]);

            echo json_encode(["status" => "success", "message" => "User registered successfully"]);
        } catch (PDOException $e) {
            echo json_encode(["status" => "error", "message" => "Failed to register user: " . $e->getMessage()]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Invalid input data"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}
?>
