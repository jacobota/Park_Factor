const { createLogger, transports, format } = require("winston");

//Winston
const logger = createLogger({
  level: "info", //means to log only messages with level 'info' and above
  format: format.combine(
    format.timestamp(),
    format.printf(({ timestamp, level, message }) => {
      return `${timestamp} [${level}]: ${message}`;
    }),
  ),
  transports: [
    new transports.Console(),
    new transports.File({filename: 'error.log', level: 'error'}),
    new transports.File({ filename: "app.log" }),
  ],
});

module.exports = {
    logger: logger
}