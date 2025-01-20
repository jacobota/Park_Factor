// imports
const {DynamoDBClient} = require('@aws-sdk/client-dynamodb');
const {DynamoDBDocumentClient, PutCommand, ScanCommand, GetCommand, UpdateCommand, DeleteCommand} = require('@aws-sdk/lib-dynamodb');
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
const TableName = process.env.VERIFIEDPOSTS_TABLENAME;

/**
 * createVerifiedPostDAO will PUT a new verified post in Park Factors Verified Post table in DynamoDB
 * 
 * @param {Object} Item postId, author, authorProfilePicture, content, postImage, createdAt, updatedAt
 * @returns nothing or an error
 */
async function createVerifiedPostDAO(Item) {
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
 * getallVerifiedPostsDAO will GET all verified posts from Park Factors Verified Post table in DynamoDB
 * 
 * @returns all verified posts from DynamoDB
 */
async function getAllVerifiedPostsDAO() {
    // Create the GetCommand to get all verified posts
    const command = new ScanCommand({
        TableName
    });

    try {
        const data = await documentClient.send(command);
        return data;
    } catch (err) {
        throw new Error(err);
    }
}

// Export functions
module.exports = {
    createVerifiedPostDAO,
    getAllVerifiedPostsDAO
};