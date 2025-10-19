const express = require('express');
const os = require('os');
const app = express();
const PORT = process.env.PORT || 3000;

// Get hostname for deployment info
const hostName = os.hostname();

// Basic endpoint with enhanced HTML
app.get('/', (req, res) => {
  res.send(`
    <html>
      <head>
        <title>Hello World App 🚀</title>
        <style>
          body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #00c6ff, #0072ff);
            color: #fff;
            text-align: center;
            padding-top: 50px;
          }
          h1 {
            font-size: 3em;
            margin-bottom: 0.2em;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
          }
          p {
            font-size: 1.5em;
            margin: 0.2em 0;
          }
          .hostname {
            margin-top: 20px;
            font-style: italic;
            color: #ffeb3b;
          }
          .emoji {
            font-size: 2em;
          }
          .button {
            margin-top: 30px;
            padding: 10px 20px;
            font-size: 1.2em;
            border: none;
            border-radius: 5px;
            background-color: #ff5722;
            color: #fff;
            cursor: pointer;
          }
          .button:hover {
            background-color: #e64a19;
          }
        </style>
      </head>
      <body>
        <h1>Hello, World! <span class="emoji">🚀</span></h1>
        <p>Deployed on Kubernetes with CI/CD</p>
        <p class="hostname">Pod: ${hostName}</p>
        <button class="button" onclick="alert('Keep rocking your CI/CD pipeline!')">Click Me!</button>
      </body>
    </html>
  `);
});

// Health check endpoint
app.get('/healthz', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

// Listen on all interfaces
app.listen(PORT, '0.0.0.0', () => {
  console.log(`✅ Server running on port ${PORT}`);
});
