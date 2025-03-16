// imports
const { logger } = require("../util/logger");
const encrypt = require("../util/encryption");
const usersDao = require("../repository/UsersDAO");

/**
 * createUser will bridge the gap between the controller and the DAO to create a new user in the database, 
 * this function will validate the username, email, and password, check if the user already exists in 
 * the database and also encrypts the password before storing it in the database.
 * 
 * @param {Object} body username, email, and password
 * @returns user data
 * @throws error if user already exists or invalid data or database error
 */
async function createUser(body) {
    try {
        // Validate the username, email, and password
        if (!validateUsername(body.username) || typeof body.username !== 'string' || !body.username) {
            throw new Error('Invalid Username');
        }

        if (typeof body.email !== 'string' || !body.email) {
            throw new Error('Invalid Email');
        }

        if (!validatePassword(body.password) || typeof body.password !== 'string' || !body.password) {
            throw new Error('Invalid Password');
        }

        // Check if the user already exists
        if (!await userExists(body.username)) {
            // Encrypt the password and pass data to DAO
            const encryptedPassword = await encrypt.encryptPassword(body.password);
            const userData = {
                username: body.username,
                admin: false,
                email: body.email,
                followingPlayers: [],
                followingTeams: [],
                favoritePlayer: "",
                favoriteTeam: "",
                userTag: "",
                userBiography: "",
                userLikedPosts: [],
                password: encryptedPassword,
                profilePicture: "",
                verified: false,
            }
            await usersDao.createUser(userData);
            return userData;
        }
        throw new Error("User already exists");
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * loginUser will bridge the gap between the controller and the DAO to login a user, this
 * function will validate username and password, check if the user exists in the database, gather the 
 * user data if it does exist, and then validate the password.
 * 
 * @param {Object} body username and password
 * @returns data of user if username and password is correct
 * @throws error if user does not exist, invalid data, or incorrect password
 */
async function loginUser(body) {
    try {
        // Validate the username and password
        if (!validateUsername(body.username) || typeof body.username !== 'string' || !body.username) {
            throw new Error('Invalid Username. Please Reenter.');
        }

        if (!validatePassword(body.password) || typeof body.password !== 'string' || !body.password) {
            throw new Error('Invalid Password. Please Reenter.');
        }

        // Check if the user exists or throw a no user found error
        const data = await usersDao.getUserByUsername(body.username);
        if (data.Item) {
            // Validate the password, if correct then return the user data else throw error
            if (await encrypt.validatePassword(body.password, data.Item.password)) {
                return data;
            }
            throw new Error("Incorrect Password. Please Try Again.");
        }
        throw new Error("No User found with entered username. Please Try Again.");
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * getUserInformation will bridge the gap between the controller and the DAO to get a user,
 * this function will be used for both gathering own user information and other user information.
 * 
 * @param {string} username username of user to get information
 * @returns data of user if present
 * @throws error if user not found or database error
 */
async function getUserInformation(username) {
    try {
        // Check if the user exists and get user information
        if (await userExists(username)) {
            const data = await usersDao.getUserByUsername(username);
            return data;
        }
        throw new Error("Username not found");
    } catch (err) {
        throw Error(err.message);
    }
}

/**
 * updateUserEmail will bridge the gap between the controller and the DAO to update a users email,
 * this function validates the email, checks if the user exists in the database and then update their email.
 * 
 * @param {String} username username to search for in the table
 * @param {String} newEmail new username
 * @returns updated email 
 * @throws error if invalid email or username not found or database error
 */
async function updateUserEmail(username, newEmail) {
    try {
        // Validate the email
        if (typeof newEmail !== 'string' || !newEmail) {
            throw new Error('Invalid Email');
        }

        // Check if the user exists and update email
        if (await userExists(username)) {
            await usersDao.updateEmail(username, newEmail);
            return newEmail;
        }
        throw new Error("Username not found");
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * updateUserPassword will bridge the gap between the controller and the DAO to update a users password,
 * this function validates the password, check if the user exists in the database and then update their password.
 * 
 * @param {String} username username to search for in the table
 * @param {String} newPassword new password
 * @returns new password
 * @throws error if invalid password or username not found or database error
 */
async function updateUserPassword(username, newPassword) {
    try {
        // Validate the password
        if (!validatePassword(newPassword) || typeof newPassword !== 'string' || !newPassword) {
            throw new Error('Invalid Password');
        }

        // Check if the user exists and update password
        if (await userExists(username)) {
            const encryptedPassword = await encrypt.encryptPassword(newPassword);
            await usersDao.updatePassword(username, encryptedPassword);
            return encryptedPassword;
        }
        throw new Error("Username not found");
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * updateProfilePicture will bridge the gap between the controller and the DAO to update a users profile picture,
 * this function will check if the user exists in the database and then update their profile picture.
 * 
 * @param {String} username username to update profile picture
 * @param {String} profilePicture new profile picture
 * @returns profile picture
 * @throws error if username not found or database error
 */
async function updateProfilePicture(username, profilePicture) {
    try {
        // check if the user exists and update profile picture
        if (await userExists(username)) {
            await usersDao.updateUserProfilePicture(username, profilePicture);
            return profilePicture;
        }
        throw new Error("Username not found");
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * updateFollowingTeams will bridge the gap between the controller and the DAO to update a users following teams,
 * this function will check if the user exists in the database and then update their following teams.
 * 
 * @param {String} username username to update following teams
 * @param {Array} followingTeams array of following teams
 * @returns following teams
 * @throws error if username not found or database error
 */
async function updateFollowingTeams(username, followingTeams) {
    try {
        // Check if the user exists and update following teams
        if (await userExists(username)) {
            await usersDao.updateUsersFollowingTeams(username, followingTeams);
            return followingTeams;
        }
        throw new Error("Username not found");
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * updateFollowingPlayers will bridge the gap between the controller and the DAO to update a users following players,
 * this function will check if the user exists in the database and then update their following players.
 * 
 * @param {String} username username to update following players
 * @param {Array} followingPlayers array of following players
 * @returns following players
 * @throws error if username not found or database error
 */
async function updateFollowingPlayers(username, followingPlayers) {
    try {
        // Check if the user exists and update following players
        if (await userExists(username)) {
            await usersDao.updateUsersFollowingPlayers(username, followingPlayers);
            return followingPlayers;
        }
        throw new Error("Username not found");
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * updateFavoriteTeam will bridge the gap between the controller and the DAO to update a users favorite team,
 * this function will check if the user exists in the database and then update their favorite team.
 * 
 * @param {String} username username to update favorite team
 * @param {Array} favoriteTeam array of favorite team
 * @returns favorite team
 * @throws error if username not found or database error
 */
async function updateFavoriteTeam(username, favoriteTeam) {
    try {
        // Check if the user exists and update following players
        if (await userExists(username)) {
            await usersDao.updateUsersFavoriteTeam(username, favoriteTeam);
            return favoriteTeam;
        }
        throw new Error("Username not found");
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * UpdateFavoritePlayer will bridge the gap between the controller and the DAO to update a users favorite player,
 * this function will check if the user exists in the database and then update their favorite player.
 * 
 * @param {String} username username to update favorite player
 * @param {Array} favoritePlayer array of favorite player
 * @returns favorite player
 * @throws error if username not found or database error
 */
async function updateFavoritePlayer(username, favoritePlayer) {
    try {
        // Check if the user exists and update favorite player
        if (await userExists(username)) {
            await usersDao.updateUsersFavoritePlayer(username, favoritePlayer);
            return favoritePlayer;
        }
        throw new Error("Username not found");
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * updateUserTag will bridge the gap between the controller and the DAO to update a users user tag,
 * this function will check if the user exists in the database and then update their user tag.
 * 
 * @param {String} username username to update user tag
 * @param {Array} userTag array of user tag
 * @returns user tag
 * @throws error if username not found or database error
 */
async function updateUserTag(username, userTag) {
    try {
        // Check if the user exists and update user tag
        if (await userExists(username)) {
            await usersDao.updateUsersUserTag(username, userTag);
            return userTag;
        }
        throw new Error("Username not found");
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * updateUserBiography will bridge the gap between the controller and the DAO to update a users user biography,
 * this function will check if the user exists in the database and then update their user biography.
 * 
 * @param {String} username username to update user biography
 * @param {Array} userBiography array of user biography
 * @returns user biography
 * @throws error if username not found or database error
 */
async function updateUserBiography(username, userBiography) {
    try {
        // Check if the user exists and update user biography
        if (await userExists(username)) {
            await usersDao.updateUsersUserBiography(username, userBiography);
            return userBiography;
        }
        throw new Error("Username not found");
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * updateLikedPosts will bridge the gap between the controller and the DAO to update a users liked posts,
 * this function will check if the user exists in the database and then update their liked posts.
 * 
 * @param {String} username username to update liked posts
 * @param {Array} likedPosts array of liked posts
 * @returns liked posts
 * @throws error if username not found or database error
 */
async function updateLikedPosts(username, likedPosts) {
    try {
        // Check if the user exists and update liked posts
        if (await userExists(username)) {
            await usersDao.updateUsersLikedPosts(username, likedPosts);
            return likedPosts;
        }
        throw new Error("Username not found");
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * toggleAdmin will bridge the gap between the controller and the DAO to toggle a users admin status,
 * this function will check if the user making the call is an admin, if the user making the call is changing
 * their own status, and will check if the user exists in the database and then toggle their admin status.
 * 
 * @param {String} adminUser requesting admin user
 * @param {String} username username to toggle admin
 * @returns data of toggled user
 * @throws error if user not found, user must have admin privileges, or cannot change own admin status
 */
async function toggleAdmin(adminUser, username) {
    try {
        // Check if the adminUser is indeed an admin
        if (!adminUser.admin) {
            throw new Error('User must have admin privileges');
        }

        // Check if the adminUser is trying to change their own admin status
        if (adminUser.username === username) {
            throw new Error('Cannot change own admin status');
        }

        // Check if the user to toggle exists and then toggle admin status
        if (await userExists(username)) {
            const data = await usersDao.toggleUserAdmin(username);
            return { username: data.Item.username, adminStatus: data.Item.admin };
        }

        throw new Error("User not found");
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * toggleVerified will bridge the gap between the controller and the DAO to toggle a users verified status,
 * this function will check if the user making the call is an admin, if the user making the call is changing
 * their own status, and will check if the user exists in the database and then toggle their verified status.
 * 
 * @param {String} adminUser requesting admin user
 * @param {String} username username to toggle verified
 * @returns data of toggled user
 * @throws error if user not found, user must have admin privileges, or cannot change own verified status
 */
async function toggleVerified(adminUser, username) {
    try {
        // Check if the adminUser is indeed an admin
        if (!adminUser.admin) {
            throw new Error('User must have admin privileges');
        }

        // Check if the adminUser is trying to change their own verified status
        if (adminUser.username === username) {
            throw new Error('Cannot change own verified status');
        }

        // Check if the user to toggle exists and then toggle verified status
        if (await userExists(username)) {
            const data = await usersDao.toggleUserVerified(username);
            return { username: data.Item.username, adminStatus: data.Item.verified };
        }

        throw new Error("User not found");
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * deleteUser will bridge the gap between the controller and the DAO to delete a user from the database,
 * this function will check if the user exists in the database and then delete the user.
 * 
 * @param {String} username username to delete
 * @returns deleted username
 * @throws error if username not found or database error
 */
async function deleteUser(username) {
    try {
        // check if the user exists and delete the user
        if (await userExists(username)) {
            await usersDao.deleteUserAccount(username);
            return username;
        }
        throw new Error("Username not found");
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * deleteUserAdminPermission will bridge the gap between the controller and the DAO to delete another user account,
 * checks if user calling is an admin, and then calls the deleteUser function.
 * 
 * @param {Object} adminUser requesting admin user
 * @param {String} username username to delete
 * @returns delete user
 * @throws error if user must have admin privileges or database
 */
async function deleteUserAdminPermission(adminUser, username) {
    try {
        // check if the user is an admin and then call deleteUser function
        if (adminUser.admin) {
            const deletedUser = await deleteUser(username);
            return deletedUser;
        }
        throw new Error('User must have admin privileges');
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * Helper function that checks if a user exists in the database
 *
 * @param {string} username to pass to GetCommand in DAO
 * @returns boolean
 */
async function userExists(username) {
    // use getUserbyUsername from DAO to check if user exists return true if it does
    const data = await usersDao.getUserByUsername(username);

    if (data.Item) {
        return true;
    } else {
        return false;
    }
}

/**
 * Helper function to validate the username of the user:
 * Blacklist characters that are not allowed but allow for a username to be between 
 * 5 and 20 characters and numbers are good.
 * 
 * @param {string} username 
 * @returns boolean
 */
function validateUsername(username) {
    // Blacklist of characters that are not allowed in the username
    const blacklist = ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "=", "+", "{", "}", "[", "]", "|", "\\", ":", ";", "'", "\"", "<", ">", ",", ".", "?", "/"];
    
    // check if the username has any blacklisted characters
    for (let char of username) {
        if (blacklist.includes(char)) {
            return false;
        }
    }

    // Username must be between 5 and 15 characters
    return username.length >= 5 && username.length <= 15;
}

/**
 * Helper function that validates a password:
 * Password must be between 8 and 20 characters, can use any symbol, numbers, and letters.
 * 
 * @param {string} password 
 * @returns boolean
 */
function validatePassword(password) {
    return password.length >= 8 && password.length <= 20;
}

// Export functions
module.exports = {
    createUser,
    loginUser,
    getUserInformation,
    updateUserEmail,
    updateUserPassword,
    updateProfilePicture,
    updateFollowingTeams,
    updateFollowingPlayers,
    updateFavoriteTeam,
    updateFavoritePlayer,
    updateUserTag,
    updateUserBiography,
    updateLikedPosts,
    toggleAdmin,
    toggleVerified,
    deleteUser,
    deleteUserAdminPermission,
    userExists
}