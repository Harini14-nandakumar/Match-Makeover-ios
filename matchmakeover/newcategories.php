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
    // Get the category name and gender from the form data
    if (isset($_POST['category_name']) && !empty(trim($_POST['category_name'])) && isset($_POST['gender']) && !empty(trim($_POST['gender']))) {
        $categoryName = trim($_POST['category_name']);
        $gender = trim($_POST['gender']); // Male or Female
        $imageDirectory = 'uploads/' . strtolower($gender) . '/'; // Directory to store images based on gender

        // Check if the gender directory exists, if not, create it
        if (!file_exists($imageDirectory)) {
            mkdir($imageDirectory, 0777, true); // Create directory with permissions
        }

        // Handle image upload
        if (isset($_FILES['image']) && $_FILES['image']['error'] == UPLOAD_ERR_OK) {
            $imageName = $_FILES['image']['name'];
            // Replace spaces with underscores in the image name
            $imageName = str_replace(' ', '_', $imageName);
            $imageTmpName = $_FILES['image']['tmp_name'];
            $imagePath = $imageDirectory . basename($imageName); // Path to save image

            // Move the uploaded image to the directory
            if (move_uploaded_file($imageTmpName, $imagePath)) {
                // Image uploaded successfully, store category name and image path
                try {
                    // Check if the category already exists
                    $stmt = $pdo->prepare("SELECT COUNT(*) FROM categories WHERE name = :name");
                    $stmt->execute(['name' => $categoryName]);
                    $count = $stmt->fetchColumn();

                    if ($count > 0) {
                        echo json_encode(["status" => "error", "message" => "Category already exists"]);
                        exit;
                    }

                    // Insert the new category along with the image path and gender
                    $stmt = $pdo->prepare("INSERT INTO categories (name, image, gender) VALUES (:name, :image, :gender)");
                    $stmt->execute(['name' => $categoryName, 'image' => $imagePath, 'gender' => $gender]);

                    echo json_encode(["status" => "success", "message" => "Category added successfully", "image_path" => $imagePath]);
                } catch (PDOException $e) {
                    echo json_encode(["status" => "error", "message" => "Failed to add category: " . $e->getMessage()]);
                }
            } else {
                echo json_encode(["status" => "error", "message" => "Failed to upload image"]);
            }
        } else {
            echo json_encode(["status" => "error", "message" => "No image uploaded or there was an upload error"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Invalid category name or gender"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}
?>
