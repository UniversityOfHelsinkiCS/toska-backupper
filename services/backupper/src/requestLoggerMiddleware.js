var morgan = require('morgan')

const requestLogger = morgan((tokens, req, res) => {
  const data = {
    userId: req.headers.uid,
    method: tokens.method(req, res),
    url: tokens.url(req, res),
    status: tokens.status(req, res),
    responseTime: tokens['response-time'](req, res),
  }

  console.log(JSON.stringify(data))
})

module.exports = requestLogger
