// imports
const { logger } = require("../util/logger");
const express = require("express");
const usersService = require("../service/UsersService");
const { generateToken, authenticateToken } = require("../util/token");

// Create the router
const router = express.Router();

// Call hello world
router.get('/', async (req, res) => {
    try {
        const response = await fetch('http://127.0.0.1:5000');
        const data = await response.json();
        res.status(200).json({ message: data.message });
    }   
    catch (err) {
        res.status(400).json({ message: err.message });
    }
});

module.exports = router;