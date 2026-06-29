// imports
const express = require("express");
// in case I want authentication
const { authenticateToken } = require("../util/token");
const dotenv = require('dotenv');
const path = require('path');
const axios = require('axios');

// Gain access to the environment variables
const envPath = path.resolve('./.env');
dotenv.config({path: envPath});
const apiKey = process.env.NEWS_API_KEY;

// Create the router
const router = express.Router();

// Get News Around the League
router.get("/", async (req, res) => {
    try {
        // NOTE: the old `sources=bleacher-report,espn` filter returns 0 results on the current
        // NewsAPI plan, so we query broadly for MLB baseball and sort by recency instead.
        const response = await axios.get(`https://newsapi.org/v2/everything?q=MLB%20baseball&language=en&sortBy=publishedAt&apiKey=${apiKey}`);
        const articles = response.data.articles;
        res.status(200).json(articles);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Get News for a Specific Team
router.get("/:team", (req, res) => {
    const team = req.params.team;
    axios.get(`https://newsapi.org/v2/everything?q=MLB%20${encodeURIComponent(team)}&language=en&sortBy=publishedAt&apiKey=${apiKey}`)
        .then(response => {
            const articles = response.data.articles;
            res.status(200).json(articles);
        })
        .catch(err => {
            res.status(400).json({message: err.message});
        });
});

module.exports = router;