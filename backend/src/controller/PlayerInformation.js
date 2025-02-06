// imports
const express = require("express");
const { authenticateToken } = require("../util/token");
const dotenv = require('dotenv');
const path = require('path');

// Gain access to the environment variables
const envPath = path.resolve('./.env');
dotenv.config({path: envPath});
const flaskUrl = process.env.FLASK_URL;

// Create the router
const router = express.Router();

// Get all mlb players and their id's
router.get('/mlb-players', async (req, res) => {
    try {
        const response = await fetch(`${flaskUrl}/players/api/mlb-players`);
        const data = await response.json();
        res.status(200).json(data);
    }   
    catch (err) {
        res.status(400).json(err.message);
    }
});

// Get an MLB players id by their first and last name
router.get('/player-id/:first/:last', async (req, res) => {
    try {
        const response = await fetch(`${flaskUrl}/players/api/playerid?last=${req.params.last}&first=${req.params.first}`);
        const data = await response.json();
        res.status(200).json(data);
    }
    catch (err) {
        res.status(400).json(err.message);
    }
});

// Get MLB player biography if possible, some players may have incomplete info
router.get('/player-bio/:bbrefid/:mlbamid', async (req, res) => {
    try {
        const response = await fetch(`${flaskUrl}/players/api/player-bio?bbref-id=${req.params.bbrefid}&mlbam-id=${req.params.mlbamid}`);
        const data = await response.json();
        res.status(200).json(data);
    }
    catch (err) {
        res.status(400).json(err.message);
    }
});

module.exports = router;