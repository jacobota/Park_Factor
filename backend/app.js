//imports
const express = require("express");
const { logger } = require("./src/util/logger");

// Routers (TODO)
const usersController = require('./src/controller/UsersController');
const verifiedPostsController = require('./src/controller/VerifiedPostsController');
const playerInformationController = require('./src/controller/PlayerInformationController');
const hitterStatsController = require('./src/controller/HitterStatsController');
const pitcherStatsController = require('./src/controller/PitcherStatsController');
const teamInformationController = require('./src/controller/TeamInformationController');
const teamStatsController = require('./src/controller/TeamStatsController');
const newsController = require('./src/controller/NewsController');

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
app.use('/verifiedPosts', verifiedPostsController);
app.use('/players', playerInformationController);
app.use('/hitters', hitterStatsController);
app.use('/pitchers', pitcherStatsController);
app.use('/teams', teamInformationController);
app.use('/teamStats', teamStatsController);
app.use('/news', newsController);