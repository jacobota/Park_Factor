// imports
const { logger } = require("../util/logger");
const encrypt = require("../util/encryption");
const usersDao = require("../repository/UsersDAO");

/**
 * 
 */
async function createUser(body) {
    try {
        if(await userExists(body.username)) {
            const encryptedPassword = await encrypt.encryptPassword(body.password);
            const data = await usersDao.createUser({
                username: body.username,
                email: body.email,
                password: encryptedPassword
            });
            return data;
        }
        throw Error("User already exists");
    } catch (err) {
        throw Error(err.message);
    }
}

/**
 * 
 */
async function loginUser(body) {
    try {
        const data = await usersDao.getUserByUsername(body.username);
        if(data.Item) {
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
    loginUser
}