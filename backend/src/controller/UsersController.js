// imports
const { logger } = require("../util/logger");
const express = require("express");
const usersService = require("../service/UsersService");
const { generateToken, authenticateToken } = require("../util/token");

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

        // Implement Validation of Email function (TODO)
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
// Get own User information (Need authenticate token middleware)
router.get('/profile', authenticateToken, async (req, res) => {
    try {
        // Call the service to get the user information
        const data = await usersService.getUserInformation(req.user.username);

        // Return the user information
        res.status(200).json(data.Item);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Get another User information (Need authenticate token middleware)
router.get('/profile/:username', authenticateToken, async (req, res) => {
    try {
        // Call the service to get the user information
        const data = await usersService.getUserInformation(req.params.username);

        // Only can see verified users currently 
        if (!data.Item.verified) {
            throw new Error("Cannot view unverified users");
        }

        // Return the user information
        res.status(200).json(data.Item);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// UPDATE
// Update own User information Email (Need authenticate token middleware)
router.put('/update/email', authenticateToken, async (req, res) => {
    try {
        // Validate the email
        if (typeof req.body.email !== 'string' || !req.body.email) {
            res.status(400).json({message: 'Invalid Email'});
            return;
        }

        // Call the service to update the user email
        const data = await usersService.updateUserEmail(req.user.username, req.body.email);

        // Return the user information
        res.status(200).json(data);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Update own User information Password (Need authenticate token middleware)
router.put('/update/password', authenticateToken, async (req, res) => {
    try {
        // Validate the email
        if (!validatePassword(req.body.password) || typeof req.body.password !== 'string' || !req.body.password) {
            res.status(400).json({message: 'Invalid Password'});
            return;
        }

        // Call the service to update the user email
        const data = await usersService.updateUserPassword(req.user.username, req.body.password);

        // Return the user information
        res.status(200).json(data);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Update own User information Profile Pic (Need authenticate token middleware) (TODO)

// Update own User Favorite Team(s) (Need authenticate token middleware) (TODO)

// Update own User Favorite Player(s) (Need authenticate token middleware) (TODO)

// Toggle another User admin status (Need Admin permissions) (TODO)
router.put('/update/admin/:username', authenticateToken, async (req, res) => {
    try {
        // check admin status of req.user
        if (req.user.admin) {
            // User can't change their own admin status
            if (req.user.username === req.params.username) {
                res.status(403).json({message: 'Cannot change own admin status'});
                return;
            }
            // Call the service to toggle the user admin status
            const data = await usersService.toggleAdmin(req.params.username);
            
            // Return the user information
            res.status(200).json({username: data.Item.username, adminStatus: data.Item.admin});
        } else {
            res.status(403).json({message: 'User must have admin priveleges'});
        }        
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

//Update another User verified status (Need Admin permissions) (TODO)

// DELETE
// Delete Account (TODO)


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

// Validate Email (TODO)

module.exports = router;