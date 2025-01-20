// imports
const { logger } = require("../util/logger");
const uuid = require("uuid");
const verifiedPostDAO = require("../repository/VerifiedPostsDAO");

/**
 * createVerifiedPost bridges the gap between the controller and the DAO to create a new
 * verified post in the database. It checks if the user is verified, if the post content is
 * too long, if the post content is valid, and if the postImage is there. If all checks pass,
 * it will create the verified post.
 * 
 * @param {Object} user verified user posting
 * @param {Object} body verified post contents
 * @returns 
 */
async function createVerifiedPost(user, body) {
    try {
        //ensure the user posting if verified
        if(user.verified) {
            // check if post content is too long
            if(!validateContentofPost(body.content)) {
                throw new Error("Post content is too long");
            }
            //check if post content is valid
            if(typeof body.content !== "string" || !body.content) {
                throw new Error("Post content is invalid. Please Retry.");
            }
            // check if postImage is there, if not set to empty string
            if(!body.postImage) {
                body.postImage = "";
            }
            // create the verified post 
            await verifiedPostDAO.createVerifiedPostDAO({
                postId: uuid.v4(),
                author: user.username,
                authorProfilePicture: user.profilePicture,
                content: body.content,
                postImage: body.postImage,
                createdAt: new Date().toISOString()
            });

            return;
        } else {
            throw new Error("User is not verified");
        }
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * getAllVerifiedPosts bridges the gap between the controller and the DAO to get all
 * verified posts in the database. Once it gets the data, it will sort the posts by 
 * date and time in reverse order and return it.
 * 
 * @returns all verified posts
 */
async function getAllVerifiedPosts() {
    try {
        // Call the DAO to get all verified posts
        const data = await verifiedPostDAO.getAllVerifiedPostsDAO();
        // Sort the posts by date and time in reverse order
        data.Items.sort((a, b) => {
            return b.createdAt.localeCompare(a.createdAt);
        });
        return data;
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * getVerifiedPostById bridges the gap between the controller and the DAO to get a verified
 * post by its postId. It will return the verified post if it exists, otherwise it will return
 * an error.
 * 
 * @param {String} postId postId of the verified post
 * @returns verified post or error
 */
async function getVerifiedPostById(postId) {
    try {
        // Call the DAO to get a verified post by id
        const data = await verifiedPostDAO.getVerifiedPostByIdDAO(postId);
        return data;
    } catch (err) {
        throw new Error(err.message);
    }
}

// Helper functions
/**
 * Validate the content of a post make sure it is below 255 characters (arbitrary)
 * @param {String} content 
 */
function validateContentofPost(content) {
    if (content.length > 255) {
        return false;
    }
    else {
        return true;
    }
}

// Export functions
module.exports = {
    createVerifiedPost,
    getAllVerifiedPosts,
    getVerifiedPostById
};