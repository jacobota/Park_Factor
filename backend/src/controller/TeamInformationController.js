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

// Get all MLB teams
router.get('/mlb-teams', async (req, res) => {
    try {
        const response = await fetch(`${flaskUrl}/teams/api/mlb-teams`);
        const data = await response.json();
        res.status(200).json(data);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Get ID for MLB Team by Team Acronym
router.get('/team-id/:teamAcronym', async (req, res) => {
    try {
        const response = await fetch(`${flaskUrl}/teams//api/mlb-team-id?team-name=${req.params.teamAcronym}`);
        const data = await response.json();
        res.status(200).json(data);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

module.exports = router;