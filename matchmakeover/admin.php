<?php
// Database configuration
$host = 'localhost';      // Your database host
$dbname = 'match_makeover'; // Your database name
$username = 'root';   // Your database username
$password = ''; // Your database password

// Function to authenticate user
function authenticateUser($inputUsername, $inputPassword) {
    global $pdo;

    // Prepare the SQL query to fetch the user by username
    $sql = "SELECT * FROM adminlogin WHERE username = :username";
    $stmt = $pdo->prepare($sql);
    $stmt->bindParam(':username', $inputUsername, PDO::PARAM_STR);

    // Execute the query
    $stmt->execute();

    // Fetch the user data (if any)
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    // Debugging: Check if user data was found
    if ($user) {
        // Debugging: Print the stored hashed password from the database
        echo "Stored hash: " . $user['password'] . "<br>";

        // Verify the password with password_verify()
        if (password_verify($inputPassword, $user['password'])) {
            return true; // Authentication successful
        }
    }

    return false; // Authentication failed
}

try {
    // Create PDO connection
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Get JSON input from request (assuming it's a POST request)
    $inputData = json_decode(file_get_contents('php://input'), true);

    if (isset($inputData['username']) && isset($inputData['password'])) {
        $inputUsername = $inputData['username'];
        $inputPassword = $inputData['password'];

        // Authenticate the user
        if (authenticateUser($inputUsername, $inputPassword)) {
            // Success response
            echo json_encode(['status' => 'success', 'message' => 'Login successful']);
        } else {
            // Error response for invalid credentials
            echo json_encode(['status' => 'error', 'message' => 'Invalid username or password']);
        }
    } else {
        // Error response for missing parameters
        echo json_encode(['status' => 'error', 'message' => 'Username and password are required']);
    }

} catch (PDOException $e) {
    // If there is an error, return a JSON error message
    echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
}
?>
