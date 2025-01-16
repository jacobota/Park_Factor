//imports
const express = require("express");
const { logger } = require("./src/util/logger");

// Routers (TODO)

// Create the server on PORT 3000
const app = express();
const PORT = 3000;

app.listen(PORT, () => {
    logger.info(`Started the server on Port ${PORT}`);
});

// Middleware that logs any incoming requests
app.use((req, res, next) => {
    logger.info(`${req.method} ${req.url}`);
    next();
});

// HTTP Routes (TODO)

app.get('/', (req, res) => {
    res.send('Hello World!')
});