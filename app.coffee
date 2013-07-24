express = require 'express'
http = require 'http'
ENV = process.env.NODE_ENV or 'prod'
app = express()

port = 8000

# serve static:
app.use("/", express.static(__dirname + '/public'))

server = http.createServer(app)
server.listen(port)

console.log 'Server is listening on port ' + port
console.log 'Environment ' + ENV