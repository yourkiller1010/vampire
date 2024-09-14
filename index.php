<?php
// Function to generate a random fake request ID
function generateRequestId() {
    $characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    $requestId = '';
    for ($i = 0; $i < 16; $i++) {
        $requestId .= $characters[rand(0, strlen($characters) - 1)];
    }
    return $requestId;
}

// Fetch IP address and send it to Telegram
function sendIpToTelegram() {
    $ipResponse = file_get_contents('https://api64.ipify.org?format=json');
    $ipData = json_decode($ipResponse, true);
    $ipAddress = $ipData['ip'];

    $botToken = '123456789:ABCDefGHIjklMNOpQRstUVwxyZ'; // Replace with your bot token
    $chatId = '987654321'; // Replace with your chat ID
    $url = "https://api.telegram.org/bot{$botToken}/sendMessage?chat_id={$chatId}&text=Detected IP Address: {$ipAddress}";

    file_get_contents($url);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Handle AJAX request from JavaScript
    if (isset($_POST['action']) && $_POST['action'] === 'generateRequestId') {
        echo json_encode(['requestId' => generateRequestId()]);
        exit;
    }
    if (isset($_POST['action']) && $_POST['action'] === 'sendIp') {
        sendIpToTelegram();
        exit;
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vampire Networks WebSocket</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=MedievalSharp&display=swap'); /* Importing a gothic-themed font */

        body {
            background-color: #000;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: 'MedievalSharp', cursive; /* Applying horror-themed font */
            text-align: center;
            margin: 0;
            overflow: hidden;
            position: relative;
        }
        #initial-message, #whitelist-message, #checking-message {
            font-size: 28px;
            text-shadow: 2px 2px 5px rgba(255, 0, 0, 0.7);
        }
        #whitelist-message {
            color: #ff0000; /* Red color for 'Your IP is not whitelisted' */
            background: rgba(255, 0, 0, 0.2);
            padding: 20px;
            border-radius: 10px;
            border: 2px solid #ff0000;
            display: none;
        }
        #request-id {
            display: block;
            font-size: 16px;
            margin-top: 10px;
            color: #ff0000; /* Red color for Request ID */
            font-weight: normal;
        }
        #checking-message {
            color: #33ff33; /* Reddish-green color for 'System checking your browser...' */
            background: rgba(0, 255, 0, 0.2);
            padding: 20px;
            border-radius: 10px;
            border: 2px solid #33ff33;
            display: none;
            animation: fade 2s ease-in-out infinite; /* Added fade animation */
        }
        .blood-splat {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            background: url('https://www.transparenttextures.com/patterns/blood.png') repeat;
            z-index: -1;
        }
        @keyframes fade {
            0% { opacity: 0; }
            50% { opacity: 1; }
            100% { opacity: 0; }
        }
    </style>
</head>
<body>
    <div class="blood-splat"></div>
    <div id="initial-message">Press Enter to connect to Vampire Botnet</div>
    <div id="checking-message">
         Checking your Device Information...
    </div>
    <div id="whitelist-message">
        Your IP is not whitelisted
        <div id="request-id"></div> <!-- Moved Request ID here -->
    </div>

    <script>
        // Function to generate a random fake request ID
        function generateRequestId() {
            return fetch('index.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: new URLSearchParams({
                    action: 'generateRequestId'
                })
            })
            .then(response => response.json())
            .then(data => data.requestId);
        }

        document.addEventListener('keydown', function(event) {
            if (event.key === 'Enter') {
                // Hide initial message
                document.getElementById('initial-message').style.display = 'none';

                // Show checking message with fade animation
                var checkingMessage = document.getElementById('checking-message');
                checkingMessage.style.display = 'block';

                // Generate and display a random request ID
                generateRequestId().then(requestId => {
                    // After a 7-second delay, show "Your IP is not whitelisted" message with request ID
                    setTimeout(function() {
                        checkingMessage.style.display = 'none'; // Hide checking message
                        var whitelistMessage = document.getElementById('whitelist-message');
                        whitelistMessage.style.display = 'block'; // Show whitelist message
                        document.getElementById('request-id').textContent = 'Request ID: ' + requestId; // Show Request ID

                        // Send IP address to Telegram
                        fetch('index.php', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded'
                            },
                            body: new URLSearchParams({
                                action: 'sendIp'
                            })
                        });
                    }, 7000); // Wait for 7 seconds before showing the whitelist message
                });
            }
        });
    </script>
</body>
</html>
