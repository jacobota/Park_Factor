//imports
const express = require("express");
const { logger } = require("./src/util/logger");

// Routers (TODO)
const usersController = require('./src/controller/UsersController');

// Create the server on PORT 3000
const app = express();
const PORT = 3000;

// Middleware to parse JSON bodies
app.use(express.json());

app.listen(PORT, () => {
    logger.info(`Started the server on Port ${PORT}`);
});

// Middleware that logs any incoming requests
app.use((req, res, next) => {
    logger.info(`${req.method} ${req.url}`);
    next();
});

// HTTP Routes (TODO)

app.use('/users', usersController);