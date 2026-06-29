// imports
const express = require("express");
const dotenv = require('dotenv');
const path = require('path');

// Gain access to the environment variables
const envPath = path.resolve('./.env');
dotenv.config({path: envPath});
const flaskUrl = process.env.FLASK_URL;

// Create the router
const router = express.Router();

// Get MLB player stats for current season
router.get('/stats/current-season/:fgId/:mlbamId', async (req, res) => {
    try {
        const response = await fetch(`${flaskUrl}/hitters/api/hitter-stats/current-season?fg-id=${req.params.fgId}&mlbam-id=${req.params.mlbamId}`);
        const data = await response.json();
        res.status(200).json(data);
    } catch (err) {
        res.status(400).json(err.message);
    }
});

// Get MLB player stats preview
router.get('/stats/current-season-preview/:mlbamId', async (req, res) => {
    try {
        const response = await fetch(`${flaskUrl}/hitters/api/hitter-stats/current-season-preview?mlbam-id=${req.params.mlbamId}`);
        const data = await response.json();
        res.status(200).json(data);
    } catch (err) {
        res.status(400).json(err.message);
    }
});

// Get MLB player stats for career (career totals are keyed by MLBAM id)
router.get('/stats/career/:mlbamId', async (req, res) => {
    try {
        const response = await fetch(`${flaskUrl}/hitters/api/hitter-stats/career?mlbam-id=${req.params.mlbamId}`);
        const data = await response.json();
        res.status(200).json(data);
    } catch (err) {
        res.status(400).json(err.message);
    }
});

// get MLB hitter percentiles for current season
router.get('/stats/percentiles/:mlbamId', async (req, res) => {
    try {
        const response = await fetch(`${flaskUrl}/hitters/api/hitter-stats/percentiles?mlbam-id=${req.params.mlbamId}`);
        const data = await response.json();
        res.status(200).json(data);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// get hitting leaderboard stats
router.get('/stats/leaderboard', async (req, res) => {
    try {
        const response = await fetch(`${flaskUrl}/hitters/api/hitter-stats/leaderboard`);
        const data = await response.json();
        res.status(200).json({'playerHittingLeaderboard': data});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

module.exports = router;