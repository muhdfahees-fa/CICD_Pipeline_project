const express = require('express');
const app = express();
const PORT = process.env.PORT || 8000;

// Basic endpoint
app.get('/', (req, res) => {
  res.send('<h1>Hello, World! 🚀</h1><p>Deployed on Kubernetes with CI/CD</p>');
});

// Health check endpoint (useful for Kubernetes liveness/readiness)
app.get('/healthz', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

// Listen on all interfaces so container is accessible externally
app.listen(PORT, '0.0.0.0', () => {
  console.log(`✅ Server running on port ${PORT}`);
});

