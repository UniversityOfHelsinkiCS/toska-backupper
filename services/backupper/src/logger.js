/**
 * Levels from Winston's documentation
 * https://github.com/winstonjs/winston
 */
const levels = {
  error: 0,
  warn: 1,
  info: 2,
  http: 3,
  verbose: 4,
  debug: 5,
  silly: 6,
}

function info(message) {
  console.log(
    JSON.stringify({
      level: levels.info,
      message,
    })
  )
}

function error(message, trace) {
  console.log(
    JSON.stringify({
      level: levels.error,
      message,
      trace: trace ? trace.toString() : undefined,
    })
  )
}

module.exports = {
  info,
  error,
}
