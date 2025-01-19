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
 * @returns data of newly created user
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
            const data = await usersDao.createUser({
                username: body.username,
                admin: false,
                email: body.email,
                favoritePlayers: [],
                favoriteTeams: [],
                password: encryptedPassword,
                profilePicture: "",
                verified: false,
            });
            return data;
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
 * @returns data of user if present or error
 */
async function getUserInformation(username) {
    try {
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
 * @param {*} newEmail new username
 * @returns data of user if changed or error
 */
async function updateUserEmail(username, newEmail) {
    try {
        // Validate the email
        if (typeof newEmail !== 'string' || !newEmail) {
            throw new Error('Invalid Email');
        }

        // Check if the user exists
        if (await userExists(username)) {
            const data = await usersDao.updateEmail(username, newEmail);
            return data;
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
 * @param {*} newPassword new password
 * @returns data of user if changed or error
 */
async function updateUserPassword(username, newPassword) {
    try {
        // Validate the password
        if (!validatePassword(newPassword) || typeof newPassword !== 'string' || !newPassword) {
            throw new Error('Invalid Password');
        }

        // Check if the user exists
        if (await userExists(username)) {
            const encryptedPassword = await encrypt.encryptPassword(newPassword);
            const data = await usersDao.updatePassword(username, encryptedPassword);
            return data;
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
 * @returns 
 */
async function updateProfilePicture(username, profilePicture) {
    try {
        if (await userExists(username)) {
            const data = await usersDao.updateUserProfilePicture(username, profilePicture);
            return data;
        }
        throw new Error("Username not found");
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * updateFavoriteTeams will bridge the gap between the controller and the DAO to update a users favorite teams,
 * this function will check if the user exists in the database and then update their favorite teams.
 * 
 * @param {String} username username to update favorite teams
 * @param {Array} favoriteTeams array of favorite teams
 * @returns 
 */
async function updateFavoriteTeams(username, favoriteTeams) {
    try {
        // Check if the user exists
        if (await userExists(username)) {
            const data = await usersDao.updateUsersFavoriteTeams(username, favoriteTeams);
            return data;
        }
        throw new Error("Username not found");
    } catch (err) {
        throw new Error(err.message);
    }
}

/**
 * updateFavoritePlayers will bridge the gap between the controller and the DAO to update a users favorite players,
 * this function will check if the user exists in the database and then update their favorite players.
 * 
 * @param {String} username username to update favorite players
 * @param {Array} favoritePlayers array of favorite players
 * @returns 
 */
async function updateFavoritePlayers(username, favoritePlayers) {
    try {
        // Check if the user exists
        if (await userExists(username)) {
            const data = await usersDao.updateUsersFavoritePlayers(username, favoritePlayers);
            return data;
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
 * @returns data of toggled user or error
 */
async function toggleAdmin(adminUser, username) {
    try {
        // Check if the adminUser is an admin
        if (!adminUser.admin) {
            throw new Error('User must have admin privileges');
        }

        // Check if the adminUser is trying to change their own admin status
        if (adminUser.username === username) {
            throw new Error('Cannot change own admin status');
        }

        // Check if the user to toggle exists
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
 * @returns data of toggled user or error
 */
async function toggleVerified(adminUser, username) {
    try {
        // Check if the adminUser is an admin
        if (!adminUser.admin) {
            throw new Error('User must have admin privileges');
        }

        // Check if the adminUser is trying to change their own verified status
        if (adminUser.username === username) {
            throw new Error('Cannot change own verified status');
        }

        // Check if the user to toggle exists
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
 * @returns data of deleted user or error
 */
async function deleteUser(username) {
    try {
        if (await userExists(username)) {
            const data = await usersDao.deleteUserAccount(username);
            return data;
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
 * @returns data of deleted user or error
 */
async function deleteUserAdminPermission(adminUser, username) {
    try {
        if (adminUser.admin) {
            return deleteUser(username);
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
    
    for (let char of username) {
        if (blacklist.includes(char)) {
            return false;
        }
    }

    return username.length >= 5 && username.length <= 20;
}

/**
 * Helper function that validates a password:
 * Password must be between 8 and 20 characters, can use any symbol, numbers, and letters.
 * 
 * @param {string} password 
 * @returns boolean
 */
function validatePassword(password) {
    // Password must be between 8 and 20 characters
    return password.length >= 8 && password.length <= 20;
}

module.exports = {
    createUser,
    loginUser,
    getUserInformation,
    updateUserEmail,
    updateUserPassword,
    updateProfilePicture,
    updateFavoriteTeams,
    updateFavoritePlayers,
    toggleAdmin,
    toggleVerified,
    deleteUser,
    deleteUserAdminPermission
}