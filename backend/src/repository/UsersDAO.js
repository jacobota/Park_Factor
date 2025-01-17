// imports
const {DynamoDBClient} = require('@aws-sdk/client-dynamodb');
const {DynamoDBDocumentClient, PutCommand, GetCommand, UpdateCommand} = require('@aws-sdk/lib-dynamodb');
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
    const command = new PutCommand({
        TableName,
        Item
    });

    try {
        const data = await documentClient.send(command);
        return data;
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
 * @param {*} newEmail new username
 * @returns data of user if changed or null
 */
async function updateEmail(username, newEmail) {
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
        const data = await documentClient.send(command);
        return data;
    } catch (err) {
        throw new Error(err);
    }
}

module.exports = {
    createUser,
    getUserByUsername,
    updateEmail
}
