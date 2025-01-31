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
 * createVerifiedPostDAO will PUT a new verified post in Park 
 * Factors Verified Post table 
 * 
 * @param {Object} Item postId, author, authorProfilePicture, content, postImage, createdAt, updatedAt
 * @returns on success
 * @throws database error
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
 * getallVerifiedPostsDAO will GET all verified posts from Park 
 * Factors Verified Post table
 * 
 * @returns all verified posts from DynamoDB
 * @throws database error
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

/**
 * getVerifiedPostByIdDAO will GET a verified post by postId from 
 * Park Factors Verified Post table
 * 
 * @param {String} postId postId of the verified post
 * @returns post from DynamoDB
 * @throws database error
 */
async function getVerifiedPostByIdDAO(postId) {
    // Create the GetCommand to get a verified post by id
    const command = new GetCommand({
        TableName,
        Key: {
            postId
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
 * getAllVerifiedPostsByAuthorDAO will GET all verified posts by author from 
 * Park Factors Verified Post table
 * 
 * @param {String} username username of the author
 * @returns all posts by the author
 * @throws database error
 */
async function getAllVerifiedPostsByAuthorDAO(username) {
    // Create the ScanCommand to get all verified posts by author
    const command = new ScanCommand({
        TableName,
        FilterExpression: 'author = :author',
        ExpressionAttributeValues: {
            ':author': username
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
 * updateContentDAO will UPDATE the content of a verified post's content in 
 * Park Factors Verified Post table
 * 
 * @param {String} postId 
 * @param {String} content 
 * @returns on success
 * @throws database error
 */
async function updateContentDAO(postId, content) {
    // Create the UpdateCommand to update the content of a verified post
    const command = new UpdateCommand({
        TableName,
        Key: {
            postId
        },
        UpdateExpression: 'SET #content = :content',
        ExpressionAttributeNames: {
            '#content': 'content'
        },
        ExpressionAttributeValues: {
            ':content': content
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
 * updatePostImageDAO will UPDATE the post image of a verified post's postImage
 *  in Park Factors Verified Post table
 * 
 * @param {String} postId 
 * @param {String} postImage 
 * @returns on success
 * @throws database error
 */
async function updatePostImageDAO(postId, postImage) {
    // Create the UpdateCommand to update the post image of a verified post
    const command = new UpdateCommand({
        TableName,
        Key: {
            postId
        },
        UpdateExpression: 'SET #postImage = :postImage',
        ExpressionAttributeNames: {
            '#postImage': 'postImage'
        },
        ExpressionAttributeValues: {
            ':postImage': postImage
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
 * deleteVerifiedPostByIdDAO will DELETE a verified post by postId from 
 * Park Factors Verified Post table
 * 
 * @param {String} postId postId of the verified post
 * @returns on success
 * @throws database error
 */
async function deleteVerifiedPostByIdDAO(postId) {
    // Create the DeleteCommand to delete a verified post by id
    const command = new DeleteCommand({
        TableName,
        Key: {
            postId
        }
    });

    try {
        await documentClient.send(command);
        return;
    } catch (err) {
        throw new Error(err);
    }
}

// Export functions
module.exports = {
    createVerifiedPostDAO,
    getAllVerifiedPostsDAO,
    getVerifiedPostByIdDAO,
    getAllVerifiedPostsByAuthorDAO,
    updateContentDAO,
    updatePostImageDAO,
    deleteVerifiedPostByIdDAO
};