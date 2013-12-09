# simple in memory cache for compiled files.
# will private file based cache system later

_ = require 'underscore'

class Cache
  # storage structure:

  #_deps = {
    # 'xxx.coffee': ['xxx.js', 'xxx.js.map']
  #}

  #_contents = {
    # 'xxx.js': { whatever object }
  #}

  constructor: ->
    @_deps = {}
    @_contents = {}

  set: (contents, deps)->
    for file, content of contents
      @_contents[file] = content
      for dep in deps
        if not _.has(@_deps, dep)
          @_deps[dep] = []
        if _.indexOf(@_deps[dep], file) == -1
          @_deps[dep].push(file)

  get: (key)->
    return @_contents[key]

  clear: (dep)->
    for name in @_deps[dep]
      delete _contents[name]
    delete @_deps[dep]

