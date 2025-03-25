// imports
const { logger } = require("../util/logger");
const uuid = require("uuid");
const verifiedPostDAO = require("../repository/VerifiedPostsDAO");
const userDAO = require("../repository/UsersDAO");
const userService = require("./UsersService");

/**
 * createVerifiedPost bridges the gap between the controller and the DAO to create a new
 * verified post in the database. It checks if the user is verified, if the post content is
 * too long, if the post content is valid, and if the postImage is there. If all checks pass,
 * it will create the verified post.
 * 
 * @param {Object} user verified user posting
 * @param {Object} body verified post contents
 * @returns verified post data
 * @throws error if user is not verified, post content is too long, or post content is invalid, or database error
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
            const verifiedPost = {
                postId: uuid.v4(),
                author: user.username,
                authorProfilePicture: body.authorProfilePicture,
                content: body.content,
                postImage: body.postImage,
                createdAt: String(new Date().toISOString())
            }
            await verifiedPostDAO.createVerifiedPostDAO(verifiedPost);

            return verifiedPost;
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
 * @throws database error
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
 * post by its postId, if it exists. It will return the verified post if it exists, otherwise 
 * it will return an error.
 * 
 * @param {String} postId postId of the verified post
 * @returns verified post
 * @throws error if post does not exist or database error
 */
async function getVerifiedPostById(postId) {
    try {
        // Check if the post exists
        if(!await postExists(postId)) {
            throw new Error("Post does not exist");
        }
        // Call the DAO to get a verified post by id
        const data = await verifiedPostDAO.getVerifiedPostByIdDAO(postId);
        return data;
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * getAllVerifiedPostsByAuthor bridges the gap between the controller and the DAO to get all
 * verified posts by a specific author. It will check if the author is verified and return all
 * posts by the author if they exist, otherwise it will return an error.
 * 
 * @param {String} username username of the author
 * @returns all posts by the author
 * @throws error if user does not exist, user is not verified, or database error
 */
async function getAllVerifiedPostsByAuthor(username) {
    try {
        // Check if the user exists
        if(!await userService.userExists(username)) {
            throw new Error("User does not exist");
        }
        // Call getUserByUsername to check if the author is verified
        const user = await userDAO.getUserByUsername(username);
        if(user.Item.verified) {
            // Call the DAO to get all verified posts by author
            const data = await verifiedPostDAO.getAllVerifiedPostsByAuthorDAO(username);
            // Sort by date and time in reverse order
            data.Items.sort((a, b) => {
                return b.createdAt.localeCompare(a.createdAt);
            });
            return data;
        } else {
            throw new Error("User is not verified");
        }
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * updateVerifiedPostById bridges the gap between the controller and the DAO to update a verified post
 * by its postId. It will check if the post exists, if the user exists, if the user is the author of the
 * post, post content and image are different than previous, and verify post content. If all checks pass, 
 * it will update the post.
 * 
 * @param {String} username 
 * @param {String} postId 
 * @param {Object} body contains the new content and postImage
 * @returns updated Post
 * @throws error if post does not exist, user does not exist, user is not the author, post content is too long, or database error
 */
async function updateVerifiedPostById(username, postId, body) {
    try {
        // Check if the post exists
        if(!await postExists(postId)) {
            throw new Error("Post does not exist");
        }
        // Check if the user exists
        if(!await userService.userExists(username)) {
            throw new Error("User does not exist");
        }
        // Check if the user is the author of the post
        const post = await verifiedPostDAO.getVerifiedPostByIdDAO(postId);
        if(post.Item.author === username) {
            let newContent, newPostImage;
            // Check if the post content is the different then run validations
            if(body.content !== post.Item.content) {
                newContent = body.content;
                // Check if the post content is too long
                if(!validateContentofPost(newContent)) {
                    throw new Error("Post content is too long");
                }
                // Check if the post content is valid
                if(typeof newContent !== "string" || !newContent) {
                    throw new Error("Post content is invalid. Please Retry.");
                }
                // Call the DAO to update the post content
                await verifiedPostDAO.updateContentDAO(postId, newContent);
            } else {
                newContent = post.Item.content;
            }
            // Check if the postImage is different
            if(body.postImage !== post.Item.postImage) {
                newPostImage = body.postImage;
                // Call the DAO to update the post image
                await verifiedPostDAO.updatePostImageDAO(postId, newPostImage);
            } else {
                newPostImage = post.Item.postImage;
            }
            // Update the verified post
            const updatedPost = {
                postId: postId,
                content: newContent,
                postImage: newPostImage
            }
            return updatedPost;
        } else {
            throw new Error("User is not the author of the post");
        }
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * deleteVerifiedPostById bridges the gap between the controller and the DAO to delete a verified
 * post by its postId. It will check if the post exists, if the user exists, and if the user is the
 * author of the post. If all checks pass, it will delete the post.
 * 
 * @param {Object} user user object
 * @param {String} postId postId of the post to delete
 * @returns on success
 * @throws error if post does not exist, user does not exist, user is not the author, or database error
 */
async function deleteVerifiedPostById(user, postId) {
    try {
        // Check if the post exists
        if(!await postExists(postId)) {
            throw new Error("Post does not exist");
        }
        // Check if the user exists
        if(!await userService.userExists(user.username)) {
            throw new Error("User does not exist");
        }
        // Check if the user is the author of the post
        const post = await verifiedPostDAO.getVerifiedPostByIdDAO(postId);
        if(post.Item.author === user.username) {
            // Call the DAO to delete a verified post by id
            await verifiedPostDAO.deleteVerifiedPostByIdDAO(postId);
            return;
        } else {
            throw new Error("User is not the author of the post");
        }

    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * adminDeleteVerifiedPostById bridges the gap between the controller and the DAO to delete a verified
 * post by its postId. It will check if the post exists and if the user is an admin. If all checks pass,
 * it will call deleteVerifiedPostByIdDAO to delete the post.
 * 
 * @param {Object} user admin user object
 * @param {String} postId postId of the post to delete
 * @returns on success
 * @throws error if post does not exist, user is not an admin, or database error
 */
async function adminDeleteVerifiedPostById(user, postId) {
    try {
        // Check if the user is an admin
        if(user.admin) {
            // Check if the post exists
            if(!await postExists(postId)) {
                throw new Error("Post does not exist");
            }
            // Call the DAO to delete a verified post by id
            await verifiedPostDAO.deleteVerifiedPostByIdDAO(postId);
            return;
        } else {
            throw new Error("User is not an admin");
        }
    } catch (err) {
        throw new Error(err.message);
    }
}

// Helper functions
/**
 * Validate the content of a post make sure it is below 255 characters (arbitrary)
 * @param {String} content 
 * @returns boolean
 */
function validateContentofPost(content) {
    if (content.length > 255) {
        return false;
    }
    else {
        return true;
    }
}

/**
 * Check if post exists
 * 
 * @param {String} postId postId of the post
 * @return boolean
 */
async function postExists(postId) {
    const post = await verifiedPostDAO.getVerifiedPostByIdDAO(postId);
    if(post.Item) {
        return true;
    } else {
        return false;
    }
}

// Export functions
module.exports = {
    createVerifiedPost,
    getAllVerifiedPosts,
    getVerifiedPostById,
    getAllVerifiedPostsByAuthor,
    updateVerifiedPostById,
    deleteVerifiedPostById,
    adminDeleteVerifiedPostById
};