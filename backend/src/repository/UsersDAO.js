// imports
const {DynamoDBClient} = require('@aws-sdk/client-dynamodb');
const {DynamoDBDocumentClient, PutCommand, GetCommand, UpdateCommand, DeleteCommand} = require('@aws-sdk/lib-dynamodb');
const dotenv = require('dotenv');
const path = require('path');
const { logger } = require("../util/logger");

const envPath = path.resolve('./.env')
dotenv.config({path: envPath});

// Gain access to the DynamoDBClient
const region = process.env.REGION;
const client = new DynamoDBClient({
    region: region,
    credentials: {
        secretAccessKey: process.env.SECRET_ACCESS_KEY_ID,
        accessKeyId: process.env.ACCESS_KEY_ID
    }
});
const documentClient = DynamoDBDocumentClient.from(client);
const TableName = process.env.USERS_TABLENAME;

/**
 * createUser will PUT a new user data in Park Factors Users table in DynamoDB
 * 
 * @param {Object} Item username, email, and encrypted password
 * @returns data of user info or error
 */
async function createUser(Item) {
    // Create the PutCommand to add the user to the table
    const command = new PutCommand({
        TableName,
        Item
    });

    try {
        await documentClient.send(command);
        return;
    } catch (err) {
        throw new Error(err);
    }
}

/**
 * getUserByUsername will GET the user data if there is a matching username
 * 
 * @param {String} username username to search for in the table
 * @returns data of user if present or null
 */
async function getUserByUsername(username) {
    // Create the GetCommand to retrieve the user from the table
    const command = new GetCommand({
        TableName,
        Key: {username: username}
    });

    try {
        const data = await documentClient.send(command);
        return data;
    } catch (err) {
        return null;
    }
}

/**
 * updateEmail will UPDATE the users email in the table
 * 
 * @param {String} username username to search for in the table
 * @param {*} newEmail new email
 * @returns data of user if changed or null
 */
async function updateEmail(username, newEmail) {
    // Create the UpdateCommand to update the user's email
    const command = new UpdateCommand({
        TableName,
        Key: {username: username},
        UpdateExpression: 'SET #email = :newEmail',
        ExpressionAttributeNames: {
            '#email': 'email'
        },
        ExpressionAttributeValues: {
            ':newEmail': newEmail
        }
    });

    try {
        await documentClient.send(command);
        return;
    } catch (err) {
        throw new Error(err);
    }
}

/**
 * updatePassword will UPDATE the users password in the table
 * 
 * @param {String} username username to search for in the table
 * @param {*} newPassword new password
 * @returns data of user if changed or null
 */
async function updatePassword(username, newPassword) {
    // Create the UpdateCommand to update the user's password
    const command = new UpdateCommand({
        TableName,
        Key: {username: username},
        UpdateExpression: 'SET #password = :newPassword',
        ExpressionAttributeNames: {
            '#password': 'password'
        },
        ExpressionAttributeValues: {
            ':newPassword': newPassword
        }
    });

    try {
        await documentClient.send(command);
        return;
    } catch (err) {
        throw new Error(err);
    }
}

/**
 * updateUserProfilePicture will UPDATE the users profile picture in the table
 * 
 * @param {String} username username to update profile picture
 * @param {String} profilePicture new profile picture
 * @returns 
 */
async function updateUserProfilePicture(username, profilePicture) {
    // Create the UpdateCommand to update the user's profile picture
    const command = new UpdateCommand({
        TableName,
        Key: {username: username},
        UpdateExpression: 'SET #profilePicture = :profilePicture',
        ExpressionAttributeNames: {
            '#profilePicture': 'profilePicture'
        },
        ExpressionAttributeValues: {
            ':profilePicture': profilePicture
        }
    });

    try {
        await documentClient.send(command);
        return;
    } catch (err) {
        throw new Error(err);
    }
}

/**
 * updateUsersFavoriteTeams will UPDATE the users favorite teams in the table
 * 
 * @param {String} username username to update favorite teams
 * @param {Array} favoriteTeams array of favorite teams
 * @returns 
 */
async function updateUsersFavoriteTeams(username, favoriteTeams) {
    // Create the UpdateCommand to update the user's favorite teams
    const command = new UpdateCommand({
        TableName,
        Key: {username: username},
        UpdateExpression: 'SET #favoriteTeams = :favoriteTeams',
        ExpressionAttributeNames: {
            '#favoriteTeams': 'favoriteTeams'
        },
        ExpressionAttributeValues: {
            ':favoriteTeams': favoriteTeams
        }
    });

    try {
        const data = await documentClient.send(command);
        return data;
    } catch (err) {
        throw new Error(err);
    }
}

/**
 * updateUsersFavoritePlayers will UPDATE the users favorite players in the table
 * 
 * @param {String} username username to update favorite players
 * @param {Array} favoritePlayers array of favorite players
 * @returns 
 */
async function updateUsersFavoritePlayers(username, favoritePlayers) {
    // Create the UpdateCommand to update the user's favorite players
    const command = new UpdateCommand({
        TableName,
        Key: {username: username},
        UpdateExpression: 'SET #favoritePlayers = :favoritePlayers',
        ExpressionAttributeNames: {
            '#favoritePlayers': 'favoritePlayers'
        },
        ExpressionAttributeValues: {
            ':favoritePlayers': favoritePlayers
        }
    });

    try {
        const data = await documentClient.send(command);
        return data;
    } catch (err) {
        throw new Error(err);
    }
}

/**
 * Toggles the admin status of a user
 * 
 * @param {String} username 
 * @returns 
 */
async function toggleUserAdmin(username) {
    // Retrieve the current user to access current admin access
    const getUserCommand = new GetCommand({
        TableName,
        Key: { username: username }
    });
    try {
        const userData = await documentClient.send(getUserCommand);
        const currentAdminStatus = userData.Item.admin;

        // Toggle the admin status
        const newAdminStatus = !currentAdminStatus;

        // Update the admin status
        const updateCommand = new UpdateCommand({
            TableName,
            Key: { username: username },
            UpdateExpression: 'SET #admin = :adminStatus',
            ExpressionAttributeNames: {
                '#admin': 'admin'
            },
            ExpressionAttributeValues: {
                ':adminStatus': newAdminStatus
            }
        });

        await documentClient.send(updateCommand);

        // Return new user data
        const data = await documentClient.send(getUserCommand);
        return data;
    } catch (err) {
        throw new Error(err);
    }
}

/**
 * Toggles the verfied status of a user
 * 
 * @param {String} username 
 * @returns 
 */
async function toggleUserVerified(username) {
    // Retrieve the current user to access current verified access
    const getUserCommand = new GetCommand({
        TableName,
        Key: { username: username }
    });
    try {
        const userData = await documentClient.send(getUserCommand);
        const currentVerifiedStatus = userData.Item.verified;

        // Toggle the verified status
        const newVerifiedStatus = !currentVerifiedStatus;

        // Update the verified status
        const updateCommand = new UpdateCommand({
            TableName,
            Key: { username: username },
            UpdateExpression: 'SET #verified = :verifiedStatus',
            ExpressionAttributeNames: {
                '#verified': 'verified'
            },
            ExpressionAttributeValues: {
                ':verifiedStatus': newVerifiedStatus
            }
        });

        await documentClient.send(updateCommand);

        // Return new user data
        const data = await documentClient.send(getUserCommand);
        return data;
    } catch (err) {
        throw new Error(err);
    }
}

/**
 * DELETE a user from the database
 * 
 * @param {String} username
 * @returns data of user deleted or error
 */
async function deleteUserAccount(username) {
    // Create the DeleteCommand to remove the user from the table
    const deleteCommand = new DeleteCommand({
        TableName,
        Key: { username: username }
    });

    try {
        const data = await documentClient.send(deleteCommand);
        return data;
    } catch (err) {
        throw new Error(err);
    }
}

// Export functions
module.exports = {
    createUser,
    getUserByUsername,
    updateEmail,
    updatePassword,
    updateUserProfilePicture,
    updateUsersFavoriteTeams,
    updateUsersFavoritePlayers,
    toggleUserAdmin,
    toggleUserVerified,
    deleteUserAccount
}
