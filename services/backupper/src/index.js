const express = require('express')
const multer = require('multer')
const upload = multer()
const fse = require('fs-extra')
const logger = require('./logger')

const FILE_PATH = process.env.FILE_PATH
const SECRET = process.env.SECRET
const port = process.env.PORT || 3000

if (!FILE_PATH || !SECRET) {
  logger.error('No FILE_PATH or SECRET specified.')
  process.exit(1)
}

const app = express()
app.post('*', upload.single('file'), (req, res) => {
  if (req.query.token !== SECRET) {
    logger.error(`Invalid token ${req.query.token}`)
    return res.status(401).send('Invalid token')
  }
  if (!req.file) {
    logger.error('No file received')
    return res.status(400).send('No file received')
  }

  try {
    fse.outputFile(FILE_PATH + req.path, req.file.buffer, (err) => {
      if (err) {
        logger.error(`Something went wrong while saving ${req.file.originalname}`, err)
        return res.status(500).json({
          message: 'Something went wrong',
          err,
        })
      } else {
        logger.info('File saved :) ')
        return res.status(200).send('File saved')
      }
    })
  } catch (e) {
    logger.error('Serious problem happened when saving file', e)
  }
})

app.get('*', (req, res) => {
  logger.info(req.url)
  res.send('hello there')
})

app.listen(port, () => {
  logger.info(`Listening on port ${port}`)
})
