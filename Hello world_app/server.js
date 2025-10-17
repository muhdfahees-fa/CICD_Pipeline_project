const express = require('express');
const app = express();
const PORT = process.env.PORT || 8080;

// Basic endpoint
app.get('/', (req, res) => {
  res.send('<h1>Hello, World! 🚀</h1><p>Deployed on Kubernetes with CI/CD</p>');
});

// Health check endpoint (useful for Kubernetes liveness/readiness)
app.get('/healthz', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

app.listen(PORT, () => {
  console.log(`✅ Server running on port ${PORT}`);
});
