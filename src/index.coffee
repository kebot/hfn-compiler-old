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
Q = require('q')
FS = require('q-io/fs')
async = require('async')


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
  router.get "#{options.js_path}<path:filePath>.js", (req, res)->
    filePath = path.join(ROOT, options.js_path, req.params.filePath + '.coffee')

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

  scss_compiler = (source_path)->
    deferred = Q.defer()
    exec(['sass', source_path].join(' '), (error, stdout, stderr)->
      if error
        deferred.reject error
      else
        deferred.resolve stdout
    )
    return deferred.promise

  styl_compiler = (source_path)->
    deferred = Q.defer()
    stylus = require 'stylus'
    FS.read(source_path).then((source)->
      stylus.render source.toString(), (err, css)->
        if err
          deferred.reject err
        else
          deferred.resolve css
    , deferred.reject)
    return deferred.promise

  router.get "/#{options.css_path}/<path:filePath>.css", (req, res)->
    # add cache later
    async.detect(
      # arr
      [['scss', scss_compiler], ['styl', styl_compiler]]
      # iterator(item, callback)
      , ([ext, compiler], resultToBe)->
        sourcePath = path.join(ROOT, options.css_path, req.params.filePath + '.' + ext)
        console.log sourcePath
        FS.exists(sourcePath).then (exists)->
          if not exists
            console.log sourcePath, 'not exists'
            return resultToBe(false)
          compiler(sourcePath).then((css)->
            res.writeHead(200, {'Content-Type': 'text/stylesheet'})
            res.write(css)
            res.end()
            resultToBe(true)
          , (err)->
            resultToBe(false)
          )
      # result
      , (result)->
        if not result
          req.emit 'next'
    )

  # CDN Proxy
  router.get '/cdn/<path:cdnUrl>', (path)->
    # http://l:5000/cdn/mr3.douban.com/xxxx/xxx.mp3
    theUrl = "http://" + cdnUrl
    return proxy(_.extend(url.parse(theUrl),{
      headers:
        referer: 'http://douban.fm'
    }))(this.req, this.res)

  app.router = router
  return app

exports.server = factory

