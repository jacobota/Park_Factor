const bcrypt = require('bcrypt');
const saltRounds = 10;

async function encryptPassword(password) {
    const encrypted = await bcrypt.hash(password, saltRounds);
    return encrypted;
}

async function validatePassword(inputPassword, hash) {
    return bcrypt.compare(inputPassword, hash);
}

module.exports = {
    encryptPassword,
    validatePassword
}