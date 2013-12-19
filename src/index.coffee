# h is the first lettle in hfn.

# host port
## PORT = 8964

# example path
## ROOT = './example'

# buildin modules
fs = require('fs')
path = require('path')
url = require('url')

# language helper
_ = require('underscore')

# union/connect and other helper modules
union = require('union')
connect = require('connect')
proxy = require('proxy-middleware')

factory = (options)->
  router = require('flask-router')()
  ROOT = options.root
  console.log ROOT

  app = union.createServer({
    before: [
      connect.static(ROOT),
      connect.directory(ROOT),
      proxy(_.extend(url.parse('http://api.douban.com'), {
        route: '/api',
        headers:
          referer: 'http://douban.fm'
      })),
      router.route
    ]
  })

  # For example, compile CoffeeScript on the fly
  router.get '/js/<path:filePath>.js', (req, res)->
    filePath = path.join(ROOT, '/js/', req.params.filePath + '.coffee')

    fs.readFile filePath, (err, data)->
      if err
        console.log err
        return req.emit 'next'
      # {js, sourceMap, v3SourceMap}
      r = require('coffee-script').compile(
        data.toString(),{
          bare: true
          sourceMap: true
          sourceFiles: [path.basename(filePath)]
        }
      )
      res.write(r.js)
      return res.end()

  exec = (require 'child_process').exec

  router.get '/css/<path:filePath>.css', (req, res)->
    filePath = path.join(ROOT, '/css/', req.params.filePath + '.scss')

    exec(['sass', filePath].join(' '), (error, stdout, stderr)->
      if error
        console.error error
        return (req.emit 'next')
      res.write(stdout)
      res.end()
    )

  # CDN Proxy
  router.get '/cdn/<path:cdnUrl>', (path)->
    # http://l:5000/cdn/mr3.douban.com/xxxx/xxx.mp3
    theUrl = "http://" + cdnUrl
    return proxy(_.extend(url.parse(theUrl),{
      headers:
        referer: 'http://douban.fm'
    }))(this.req, this.res)

  return app

exports.server = factory


