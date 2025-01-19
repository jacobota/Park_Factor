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
        // Call the service to create the user
        await usersService.createUser(req.body);

        // Return the user information
        res.status(201).json({message: 'User Created'});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// User log in
router.post('/login', async (req, res) => {
    try {
        // Call the service to log in the user
        const data = await usersService.loginUser(req.body);

        const jwtToken = generateToken(data.Item);

        // Return the user information and token
        res.status(200).json({user: data.Item, token: jwtToken});
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
        // Call the service to update the user email
        await usersService.updateUserEmail(req.user.username, req.body.email);
        res.status(201).json({message: 'Email Updated', email: req.body.email});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Update own User information Password (Need authenticate token middleware)
router.put('/update/password', authenticateToken, async (req, res) => {
    try {
        // Call the service to update the user password
        await usersService.updateUserPassword(req.user.username, req.body.password);
        res.status(201).json({message: 'Password Updated', password: req.body.password});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Update own User information Profile Picture (Need authenticate token middleware)
router.put('/update/profilePicture', authenticateToken, async (req, res) => {
    try {
        // Call the service to update the user profile pic
        await usersService.updateProfilePicture(req.user.username, req.body.profilePicture);
        res.status(201).json({message: 'Profile Pic Updated', profilePic: req.body.profilePicture});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Update own User Favorite Team(s) (Need authenticate token middleware)
router.put('/update/favoriteTeams', authenticateToken, async (req, res) => {
    try {
        // Call the service to update the user favorite team
        await usersService.updateFavoriteTeams(req.user.username, req.body.favoriteTeams);
        res.status(201).json({message: 'Favorite Team(s) Updated', favoriteTeams: req.body.favoriteTeams});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Update own User Favorite Player(s) (Need authenticate token middleware)
router.put('/update/favoritePlayers', authenticateToken, async (req, res) => {
    try {
        // Call the service to update the user favorite players
        await usersService.updateFavoritePlayers(req.user.username, req.body.favoritePlayers);
        res.status(201).json({message: 'Favorite Player(s) Updated', favoritePlayers: req.body.favoritePlayers});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Toggle another User admin status
router.put('/update/admin/:username', authenticateToken, async (req, res) => {
    try {
        const data = await usersService.toggleAdmin(req.user, req.params.username);
        res.status(201).json(data);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

//Update another User verified status
router.put('/update/verified/:username', authenticateToken, async (req, res) => {
    try {
        const data = await usersService.toggleVerified(req.user, req.params.username);
        res.status(201).json(data);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// DELETE
// Delete Own Account
router.delete('/delete', authenticateToken, async (req, res) => {
    try {
        // Call the service to delete the user
        await usersService.deleteUser(req.user.username);
        // Return the user information
        res.status(200).json({message: 'User Deleted', userDeleted: req.user.username});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Delete Another User Account
router.delete('/delete/:username', authenticateToken, async (req, res) => {
    try {
        // Call the service to delete the user
        await usersService.deleteUserAdminPermission(req.user, req.params.username);
        
        // Return the user information
        res.status(200).json({message: 'User Deleted', userDeleted: req.params.username});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});


module.exports = router;