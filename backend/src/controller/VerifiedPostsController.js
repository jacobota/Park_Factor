// imports
const { logger } = require("../util/logger");
const express = require("express");
const verifiedPostsService = require("../service/VerifiedPostsService");
const { authenticateToken } = require("../util/token");

// Create the router
const router = express.Router();

// CREATE
// Create a new verified post (Need authenticate token middleware)
router.post("/create", authenticateToken, async (req, res) => {
    try {
        // Call the service to create the verified post
        const data = await verifiedPostsService.createVerifiedPost(req.user, req.body);
        res.status(201).json({message: 'Verified Post Created', post: data});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// READ
// Get all verified posts (Need authenticate token middleware)
router.get("/", authenticateToken, async (req, res) => {
    try {
        // Call the service to get all verified posts
        const data = await verifiedPostsService.getAllVerifiedPosts();
        res.status(200).json(data.Items);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Get a verified post by id (Need authenticate token middleware)
router.get("/postId/:postId", authenticateToken, async (req, res) => {
    try {
        // Call the service to get a verified post by id
        const data = await verifiedPostsService.getVerifiedPostById(req.params.postId);
        res.status(200).json(data.Item);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Get all verified posts by a user (Need authenticate token middleware)
router.get("/author/:username", authenticateToken, async (req, res) => {
    try {
        // Call the service to get all verified posts by a user
        const data = await verifiedPostsService.getAllVerifiedPostsByAuthor(req.params.username);
        res.status(200).json(data.Items);
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// UPDATE
// Update a verified post by id (Need authenticate token middleware)
router.put("/update/:postId", authenticateToken, async (req, res) => {
    try {
        // Call the service to update a verified post by id
        const updatedPost = await verifiedPostsService.updateVerifiedPostById(req.user.username, req.params.postId, req.body);
        res.status(200).json({message: "Verified Post Updated", post: updatedPost});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// DELETE
// Author can delete their own verified post by id (Need authenticate token middleware)
router.delete("/delete/:postId", authenticateToken, async (req, res) => {
    try {
        // Call the service to delete a verified post by id
        await verifiedPostsService.deleteVerifiedPostById(req.user, req.params.postId);
        res.status(200).json({message: "Verified Post Deleted"});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Delete another user's verified post by id (Admin only)
router.delete("/admin/delete/:postId", authenticateToken, async (req, res) => {
    try {
        // Call the service to delete a verified post by id
        await verifiedPostsService.adminDeleteVerifiedPostById(req.user, req.params.postId);
        res.status(200).json({message: "Admin Deleted Verified Post"});
    } catch (err) {
        res.status(400).json({message: err.message});
    }
});

// Export the router
module.exports = router;