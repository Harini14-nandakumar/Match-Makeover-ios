<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

function getChatbotResponse($message) {
    // ✅ Step 1: Set your OpenAI API key (Move this to an environment variable for security!)
    $apiKey = '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'; // Replace with your actual API key

    // ✅ Step 2: Set OpenAI API URL
    $url = 'https://api.openai.com/v1/chat/completions';

    // ✅ Step 3: Prepare the request data
    $data = [
        'model' => 'gpt-3.5-turbo',  // OpenAI model
        'messages' => [
            ['role' => 'user', 'content' => $message]  // User's message
        ],
        'max_tokens' => 100  // Limit the response length
    ];

    // ✅ Step 4: Initialize cURL session
    $ch = curl_init($url);

    // ✅ Step 5: Set cURL options
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'Authorization: Bearer ' . $apiKey // Send API key in the header
    ]);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));

    // ✅ Step 6: Execute request and get response
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $curlError = curl_error($ch);

    curl_close($ch); // Close cURL session

    // ✅ Step 7: Check for cURL errors
    if ($curlError) {
        return "cURL Error: " . $curlError;
    }

    // ✅ Step 8: Decode API response
    $responseData = json_decode($response, true);

    // ✅ Step 9: Handle JSON decode errors
    if (json_last_error() !== JSON_ERROR_NONE) {
        return "JSON Decode Error: " . json_last_error_msg();
    }

    // ✅ Step 10: Handle API errors
    if ($httpCode !== 200) {
        return "API Error: " . ($responseData['error']['message'] ?? 'Unknown error');
    }

    // ✅ Step 11: Return chatbot response
    return $responseData['choices'][0]['message']['content'] ?? "No response from AI.";
}

// ✅ Step 12: Test the function
$message = "Hello, how are you?";
$response = getChatbotResponse($message);
echo $response;
?>
