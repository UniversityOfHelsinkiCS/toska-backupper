
const express = require('express')
const multer  = require('multer')
const upload = multer()
const fse = require('fs-extra');

const FILE_PATH = process.env.FILE_PATH
const SECRET = process.env.SECRET
const port = process.env.PORT || 3000

if (!FILE_PATH ||!SECRET) {
  console.log("No FILE_PATH or SECRET specified.")
  process.exit(1)
}

const app = express()

app.post('*', upload.single('file'), (req, res) => {
  if (req.query.token !== SECRET) {
    return res.status(401).send('Invalid token')
  }
  if (!req.file) {
    return res.status(400).send('No file received')
  }
  fse.outputFile(FILE_PATH + req.path, req.file.buffer , err => {
    if(err) {
      console.log(err);
      return res.status(500).send("Something went wrong", err)
    } else {
      return res.status(200).send("File saved")
    }
  })
})

app.get('*', (req, res) => {
  console.log(req.url)
  res.send('hello there')
})

app.listen(port, () => {
  console.log('Listening on port', port)
})
