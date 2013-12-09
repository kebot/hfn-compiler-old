# utils = require '../utils'
bower = require 'bower'

###
[Bower spec](https://docs.google.com/document/d/1APq7oA9tNao1UYWyOm8dKqlRP2blVkROYLZ2fLIjtWc/edit#heading=h.motxgepy7e9s)

default_configs = {
  cwd: [string],
  directory: [string],
  registry: [object string],
  registry.search: [array string],
  registry.register: [string],
  registry.publish: [string]
}
###

class Bower
  constructor: (options)->

  config: (opts)->
    @_options = _.extend(@_options, opts)

  bind_router: (router, app=null)->
    router.get '/bower_components/<package_name>/<path:file_name>', (req, res)->
      bower.install([req.params.package_name]).on('end', (installed)->
        # retry the request
        #res.redirect(req.path)
      ).on('error', (err)->
        console.log 'request with error'
      )


