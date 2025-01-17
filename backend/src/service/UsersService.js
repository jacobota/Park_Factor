// imports
const { logger } = require("../util/logger");
const encrypt = require("../util/encryption");
const usersDao = require("../repository/UsersDAO");
const { profile } = require("winston");

/**
 * createUser will bridge the gap between the controller and the DAO to create a
 * new user in the database, this function will check if the user already exists in
 * the database and also encrypts the password before storing it in the database.
 * 
 * @param {Object} body username, email, and password
 * @returns data of newly created user
 */
async function createUser(body) {
    try {
        // check if the user already exists
        if(!await userExists(body.username)) {
            // encrypt the password and pass data to DAO
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
        throw Error("User already exists");
    } catch (err) {
        throw Error(err.message);
    }
}

/**
 * loginUser will bridge the gap between the controller and the DAO to login a user, this
 * function will check if the user exists in the database, gather the user data if it does 
 * exist, and then validate the password.
 * 
 * @param {Object} body username and password
 * @returns data of user if username and password is correct
 */
async function loginUser(body) {
    try {
        // check if the user exists or throw a no user found error
        const data = await usersDao.getUserByUsername(body.username);
        if(data.Item) {
            // validate the password, if correct then return the user data else throw error
            if(await encrypt.validatePassword(body.password, data.Item.password)) {
                return data;
            }
            throw Error("Invalid Password. Please Try Again.");
        }
        throw Error("No User found with entered username. Please Try Again.");
    } catch (err) {
        throw Error(err.message);
    }
}

/**
 * getUserbyUsername will bridge the gap between the controller and the DAO to get a user,
 * this function will be used for both gathering own user information and other user information.
 * 
 * @param {string} username username of user to get information
 * @returns data of user if present or error
 */
async function getUserInformation(username) {
    try {
        const data = await usersDao.getUserByUsername(username);
        return data;
    } catch (err) {
        throw Error("Error retrieving user information");
    }
}

/**
 * Helper functin that checks if a user exists in the database
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

module.exports = {
    createUser,
    loginUser,
    getUserInformation
}