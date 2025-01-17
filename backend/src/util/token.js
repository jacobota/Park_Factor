const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');
const path = require('path');

const envPath = path.resolve('./.env')
dotenv.configDotenv({path: envPath});

// Get the Environment Variable for the Secret Key
const secretKey = process.env.PARK_FACTOR_JWT_SECRET_KEY;

/**
 * Generate the jwt token
 * 
 * @param userData Data from user on login
 * @returns jwtToken
 */
function generateToken(userData) {
    const jwtToken = jwt.sign(
        {
            userId: userData.userId,
            username: userData.username
        },
        secretKey,
        {
            expiresIn: '30m'
        }
    );
    return jwtToken;
}

/**
 * Middleware functon used to authenticate a token prior to calling a 
 * function that requires authentication
 * 
 * @param req Incoming request
 * @param res Outgoing response
 * @param next Move to next middleware/route
 */
function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        res.status(401).json({message: 'You must be logged in to use this feature'});
    } else {
        jwt.verify(token, secretKey, (err, user) => {
            if (err) {
                res.status(403).json({message: 'You do not have permission to access this feature'});
            } else {
                req.user = user;
                next();
            }
        })
    }
}

/**
 * verifyAdmin function used to verify that the user is an admin.
 * 
 * @param jwtToken JWT Token
 * @return boolean
 */
function verifyAdmin(jwtToken) {
    const decoded = jwt.decode(jwtToken);
    return decoded.admin;
}

/**
 * verifyVerified function used to verify that the user is verified.
 * 
 * @param jwtToken JWT Token
 * @return boolean
 */
function verifyVerified(jwtToken) {
    const decoded = jwt.decode(jwtToken);
    return decoded.verified;
}

module.exports = {
    jwt,
    generateToken,
    authenticateToken,
    verifyAdmin,
    verifyVerified
}