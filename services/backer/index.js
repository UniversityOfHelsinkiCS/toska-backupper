require('dotenv').config();

const { CronJob } = require('cron')

// defaults schedule to 1am
const { CRON_SCHEDULE='0 1 * * *', DB_NAME } = process.env 
const schedule = (cronTime, func) => new CronJob({ cronTime, onTick: func, start: true, timeZone: 'Europe/Helsinki' })

const { exec } = require('child_process')

console.log(`Backupping cron job initialized for ${DB_NAME} with schedule ${CRON_SCHEDULE}`)

schedule(CRON_SCHEDULE, async () => {
  console.log('Cron job starting')
  exec('bash backer-script.sh', (err, stdout, stderr) => {
    if (err) {
      console.error(`exec error: ${err}`)
      return
    }
    console.log(stdout);
  })
})
