// imports
const express = require("express");
// in case I want authentication
const { authenticateToken } = require("../util/token");
const dotenv = require('dotenv');
const path = require('path');

// Gain access to the environment variables
const envPath = path.resolve('./.env');
dotenv.config({path: envPath});
const flaskUrl = process.env.FLASK_URL;

// Create the router
const router = express.Router();

// Get season stats for a MLB team
router.get('/current-season/:teamId', async (req, res) => {
    try {
        const response = await fetch(`${flaskUrl}/team-stats/api/stats/current-season?team-fg=${req.params.teamId}`);
        const data = await response.json();
        res.status(200).json(data);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

module.exports = router;