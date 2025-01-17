// imports
const { logger } = require("../util/logger");
const express = require("express");
const usersService = require("../service/UsersService");
const { generateToken } = require("../util/token");

// Create the router
const router = express.Router();

// CREATE
// User Sign in/Registration
router.post('/registration', async (req, res) => {
    try {
        // Validate the username, email and password
        if (!validateUsername(req.body.username) || typeof req.body.username !== 'string' || !req.body.username) {
            res.status(400).json({message: 'Invalid Username'});
            return;
        }

        // Need to make a validate email function (TODO)
        if (typeof req.body.email !== 'string' || !req.body.email) {
            res.status(400).json({message: 'Invalid Email'});
            return;
        }

        if (!validatePassword(req.body.password) || typeof req.body.password !== 'string' || !req.body.password) {
            res.status(400).json({message: 'Invalid Password'});
            return;
        }
        
        // Call the service to create the user
        const data = await usersService.createUser(req.body);

        // Return the user information
        res.status(201).json({message: 'User Created'});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// User log in
router.post('/login', async (req, res) => {
    try {
        // Validate the username and password
        if (typeof req.body.username !== 'string' || !req.body.username) {
            res.status(400).json({message: 'Invalid Username. Please Reenter.'});
            return;
        }

        if (typeof req.body.password !== 'string' || !req.body.password) {
            res.status(400).json({message: 'Invalid Password. Please Reenter.'});
            return;
        }

        // Call the service to log in the user
        const data = await usersService.loginUser(req.body);

        const jwtToken = generateToken(data.Item);

        // Return the user information
        res.status(201).json({user: data.Item, token: jwtToken});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// READ
// Get own User information (Need authenticate token method)

// UPDATE
// Update own User information Username (Need authenticate token method) 

// Update own User information Email (Need authenticate token method) 

// Update own User information Password (Need authenticate token method) 

// Update own User information Profile Pic (Need authenticate token method) 

// Update own User Favorite Team(s) (Need authenticate token method)

// Update own User Favorite Player(s) (Need authenticate token method)

// Update another User admin status (Need Admin permissions)

//Update another User verified status (Need Admin permissions)

// DELETE
// Delete Account (Going to be stretch goal for now)


// Helper Functions for Username and Password Validation

/**
 * Helper function to validate the username of the user, blacklist characters that are not allowed
 * but allow for a username to be between 5 and 20 characters and numbers are good.
 * 
 * @param {string} username 
 * @returns boolean
 */
function validateUsername(username) {
    // Blacklist of characters that are not allowed in the username
    const blacklist = ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "=", "+", "{", "}", "[", "]", "|", "\\", ":", ";", "'", "\"", "<", ">", ",", ".", "?", "/"];
    
    for (let char of username) {
        if (blacklist.includes(char)) {
            return false;
        }
    }

    return username.length >= 5 && username.length <= 20;
}

/**
 * Password must be between 8 and 20 characters, can use any symbol, numbers, and letters.
 * 
 * @param {string} password 
 * @returns boolean
 */
function validatePassword(password) {
    // Password must be between 8 and 20 characters
    return password.length >= 8 && password.length <= 20;
}

module.exports = router;