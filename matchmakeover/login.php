<?php
// Enable error reporting for debugging (remove in production)
ini_set('display_errors', 1);
error_reporting(E_ALL);

require_once 'db.php'; // Database connection file

// Set response header for JSON
header('Content-Type: application/json');

// Read POST data (login credentials)
$requestData = json_decode(file_get_contents('php://input'), true);

// Check if username and password are provided
if (isset($requestData['username']) && isset($requestData['password'])) {
    $username = trim($requestData['username']);
    $password = trim($requestData['password']);

    try {
        // Prepare a parameterized SQL query to prevent SQL injection
        $stmt = $conn->prepare("SELECT username, password,role FROM signup WHERE username = ?");
        $stmt->bind_param("s", $username);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $user = $result->fetch_assoc();

            // Verify the password
            if (password_verify($password, $user['password'])) {
                // Login successful
                $response = [
                    'status' => true,
                    'message' => 'Login successful.',
                    'role' => $user['role']
                ];
            } else {
                // Invalid password
                $response = [
                    'status' => false,
                    'message' => 'Invalid username or password.'
                ];
            }
        } else {
            // Username not found
            $response = [
                'status' => false,
                'message' => 'Invalid username or password.'
            ];
        }
    } catch (Exception $e) {
        // Handle any errors
        $response = [
            'status' => false,
            'message' => 'An error occurred: ' . $e->getMessage()
        ];
    }
} else {
    // Missing username or password in the request
    $response = [
        'status' => false,
        'message' => 'Please provide both username and password.'
    ];
}

// Close the database connection
$conn->close();

// Output the response as JSON
echo json_encode($response);
?>
