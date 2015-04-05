require! {http, url, path, fs}

port = 3000

http.createServer (req, res) !->
    pathname = url.parse req.url .pathname
    mimeType = getMimeType pathname
    if !!mimeType
        handlePage req, res, pathname
    else
        handleAjax req, res
.listen port, !->
    console.log  "server listen on #port"

function getMimeType pathname
    validExtensions = 
        ".html" : "text/html",
        ".js": "application/javascript",
        ".css": "text/css",
        ".jpg": "image/jpeg",
        ".gif": "image/gif",
        ".png": "image/png"
    ext = path.extname pathname
    validExtensions.[ext]

function handlePage req, res, pathname
    filePath = __dirname + pathname
    mimeType = getMimeType pathname
    if fs.existsSync filePath
        fs.readFile filePath, (err, data) ->
            if err
                res.writeHead 500
                res.end!
            else
                res.setHeader 'Content-Length', data.length
                res.setHeader 'Content-Type', mimeType
                res.statusCOde = 200
                res.end data
    else
        res.writeHead 500
        res.end!

function handleAjax req, res
    random_time = 1000 + getRandomNumber 2000
    random_num = 1 + getRandomNumber 9
    setTimeout ->
        res.writeHead 200,  'Content-Type': 'text/plain'
        res.end '' +  random_num
    , random_time

function getRandomNumber limit
    return Math.round Math.random! * limit
