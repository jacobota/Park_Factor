//imports
const express = require("express");
const { logger } = require("./src/util/logger");

//create the server on PORT 3000
const app = express();
const PORT = 3000;

//initialize server
app.listen(PORT, () => {
    logger.info(`Started the server on Port ${PORT}`);
});

app.get('/', (req, res) => {
    res.send('Hello World!')
})