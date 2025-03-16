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
        const data = await usersService.createUser(req.body);
        res.status(201).json({message: 'User Created', user: data});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// User log in
router.post('/login', async (req, res) => {
    try {
        // Call the service to log in the user
        const data = await usersService.loginUser(req.body);

        // Generate a jwt token for the user
        const jwtToken = generateToken(data.Item);
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
        const updatedEmail = await usersService.updateUserEmail(req.user.username, req.body.email);
        res.status(201).json({message: 'Email Updated', email: updatedEmail});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Update own User information Password (Need authenticate token middleware)
router.put('/update/password', authenticateToken, async (req, res) => {
    try {
        // Call the service to update the user password
        const updatedPassword = await usersService.updateUserPassword(req.user.username, req.body.password);
        res.status(201).json({message: 'Password Updated', password: updatedPassword});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Update own User information Profile Picture (Need authenticate token middleware)
router.put('/update/profilePicture', authenticateToken, async (req, res) => {
    try {
        // Call the service to update the user profile pic
        const updatedProfilePic = await usersService.updateProfilePicture(req.user.username, req.body.profilePicture);
        res.status(201).json({message: 'Profile Pic Updated', profilePic: updatedProfilePic});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Update own User Following Team(s) (Need authenticate token middleware)
router.put('/update/followingTeams', authenticateToken, async (req, res) => {
    try {
        // Call the service to update the user following team
        const followingTeams = await usersService.updateFollowingTeams(req.user.username, req.body.followingTeams);
        res.status(201).json({message: 'Following Team(s) Updated', followingTeams: followingTeams});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Update own User Following Player(s) (Need authenticate token middleware)
router.put('/update/followingPlayers', authenticateToken, async (req, res) => {
    try {
        // Call the service to update the user following players
        const followingPlayers = await usersService.updateFollowingPlayers(req.user.username, req.body.followingPlayers);
        res.status(201).json({message: 'Following Player(s) Updated', followingPlayers: followingPlayers});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Update own User information Favorite Team (Need authenticate token middleware)
router.put('/update/favoriteTeam', authenticateToken, async (req, res) => {
    try {
        // Call the service to update the user favorite team
        const updatedFavoriteTeam = await usersService.updateFavoriteTeam(req.user.username, req.body.favoriteTeam);
        res.status(201).json({message: 'Favorite Team Updated', favoriteTeam: updatedFavoriteTeam});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Update own User information Favorite Player (Need authenticate token middleware)
router.put('/update/favoritePlayer', authenticateToken, async (req, res) => {
    try {
        // Call the service to update the user favorite player
        const updatedFavoritePlayer = await usersService.updateFavoritePlayer(req.user.username, req.body.favoritePlayer);
        res.status(201).json({message: 'Favorite Player Updated', favoritePlayer: updatedFavoritePlayer});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Update own User information tag (Need authenticate token middleware)
router.put('/update/userTag', authenticateToken, async (req, res) => {
    try {
        // Call the service to update the user tag
        const updatedUserTag = await usersService.updateUserTag(req.user.username, req.body.userTag);
        res.status(201).json({message: 'User Tag Updated', userTag: updatedUserTag});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Update own User information Biography (Need authenticate token middleware)
router.put('/update/userBiography', authenticateToken, async (req, res) => {
    try {
        // Call the service to update the user biography
        const updatedUserBiography = await usersService.updateUserBiography(req.user.username, req.body.userBiography);
        res.status(201).json({message: 'Biography Updated', profilePic: updatedUserBiography});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Update own User information Liked Posts (Need authenticate token middleware)
router.put('/update/userLikedPosts', authenticateToken, async (req, res) => {
    try {
        // Call the service to update the user liked posts
        const updatedLikedPosts = await usersService.updateLikedPosts(req.user.username, req.body.likedPosts);
        res.status(201).json({message: 'Liked Posts Updated', profilePic: updatedLikedPosts});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Toggle another User admin status
router.put('/update/admin/:username', authenticateToken, async (req, res) => {
    try {
        // call the service to toggle the users admin status
        const data = await usersService.toggleAdmin(req.user, req.params.username);
        res.status(201).json(data);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

//Update another User verified status
router.put('/update/verified/:username', authenticateToken, async (req, res) => {
    try {
        // call the service to toggle the users verified status
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
        const deletedUser = await usersService.deleteUser(req.user.username);
        res.status(200).json({message: 'User Deleted', userDeleted: deletedUser});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Delete Another User Account
router.delete('/delete/:username', authenticateToken, async (req, res) => {
    try {
        // Call the service to delete the user
        const deletedUser = await usersService.deleteUserAdminPermission(req.user, req.params.username);
        res.status(200).json({message: 'User Deleted', userDeleted: deletedUser});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Export the router
module.exports = router;