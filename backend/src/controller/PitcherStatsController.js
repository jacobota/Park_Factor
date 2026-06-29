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

// get MLB pitcher stats for current season
router.get('/stats/current-season/:fgId/:mlbamId', async (req, res) => {
    try {
        const response = await fetch(`${flaskUrl}/pitchers/api/pitcher-stats/current-season?fg-id=${req.params.fgId}&mlbam-id=${req.params.mlbamId}`);
        const data = await response.json();
        res.status(200).json(data);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// get MLB pitcher stats preview
router.get('/stats/current-season-preview/:mlbamId', async (req, res) => {
    try {
        const response = await fetch(`${flaskUrl}//pitchers/api/pitcher-stats/current-season-preview?mlbam-id=${req.params.mlbamId}`);
        const data = await response.json();
        res.status(200).json(data);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// get MLB pitcher stats for career (career totals are keyed by MLBAM id)
router.get('/stats/career/:mlbamId', async (req, res) => {
    try {
        const response = await fetch(`${flaskUrl}/pitchers/api/pitcher-stats/career?mlbam-id=${req.params.mlbamId}`);
        const data = await response.json();
        res.status(200).json(data);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// get MLB pitcher arsenal which also gives Vertical and Horizontal break
router.get('/stats/pitcher-arsenal/:mlbamId', async (req, res) => {
    try {
        const response = await fetch(`${flaskUrl}/pitchers/api/pitcher-stats/arsenal?mlbam-id=${req.params.mlbamId}`);
        const data = await response.json();
        res.status(200).json(data);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// get MLB pitcher full arsenal (per-pitch velo/IVB/HB/ext/spin/usage + Action+ proxy)
router.get('/stats/arsenal-full/:mlbamId', async (req, res) => {
    try {
        const startYear = req.query['start-year'] ? `&start-year=${req.query['start-year']}` : '';
        const response = await fetch(`${flaskUrl}/pitchers/api/pitcher-stats/arsenal-full?mlbam-id=${req.params.mlbamId}${startYear}`);
        const data = await response.json();
        res.status(200).json(data);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// get MLB pitcher percentiles for current season
router.get('/stats/percentiles/:mlbamId', async (req, res) => {
    try {
        const response = await fetch(`${flaskUrl}/pitchers/api/pitcher-stats/percentiles?mlbam-id=${req.params.mlbamId}`);
        const data = await response.json();
        res.status(200).json(data);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// get pitching leaderboard stats
router.get('/stats/leaderboard', async (req, res) => {
    try {
        const response = await fetch(`${flaskUrl}/pitchers/api/pitcher-stats/leaderboard`);
        const data = await response.json();
        res.status(200).json({'playerPitchingLeaderboard': data});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

module.exports = router;