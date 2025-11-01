<?php
header("Content-Type: application/json");

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $inputData = json_decode(file_get_contents("php://input"), true);

    if (isset($inputData['username']) && isset($inputData['message'])) {
        $username = htmlspecialchars($inputData['username']); // Prevent XSS
        $message = htmlspecialchars($inputData['message']);

        // Call the Gemini API to get a response
        $botResponse = generateChatResponse($username, $message);

        // Prepare response
        $response = [
            'username' => $username,
            'userMessage' => $message,
            'botResponse' => $botResponse,
            'status' => 'success'
        ];

        echo json_encode($response);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Invalid data']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Only POST requests are allowed']);
}

// Function to call the Gemini API with retry mechanism
function generateChatResponse($username, $message) {
    $apiKey = 'AIzaSyC_Dldif9QavTNQqmLYGvc1Kr1gQpcSFrg'; // Replace with actual API key
    $url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=' . $apiKey;

    $data = [
        "contents" => [
            [
                "parts" => [
                    ["text" => "User ($username): $message\nBot:"]
                ]
            ]
        ]
    ];

    $maxRetries = 3; // Maximum number of retries
    $retryDelay = 2; // Delay in seconds between retries

    for ($i = 0; $i < $maxRetries; $i++) {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($response === false || $httpCode !== 200) {
            $responseData = json_decode($response, true);
            $errorMessage = $responseData['error']['message'] ?? 'Unknown API error';

            // Log the error
            error_log("Gemini API Error: $errorMessage\n", 3, "gemini_log.txt");

            if ($httpCode == 503) { // If service is unavailable, retry
                sleep($retryDelay);
                continue;
            } else {
                return "API Error: $errorMessage";
            }
        }

        // Decode API response correctly
        $responseData = json_decode($response, true);
        return $responseData['candidates'][0]['content']['parts'][0]['text'] ?? "Error generating response.";
    }

    return "API Error: Service unavailable after multiple attempts.";
}
?>
