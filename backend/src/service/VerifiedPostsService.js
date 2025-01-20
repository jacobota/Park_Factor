// imports
const { logger } = require("../util/logger");
const uuid = require("uuid");
const verifiedPostDAO = require("../repository/VerifiedPostsDAO");

// Create a new verified post
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
                createdAt: new Date().toISOString(),
                updatedAt: new Date().toISOString
            });

            return;
        } else {
            throw new Error("User is not verified");
        }
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
    createVerifiedPost
};