fs = require 'fs'
jsdom = require 'jsdom'

jsdom.env {
  url: 'http://localhost:8964'
  features:
    FetchExternalResources: ['script', 'css']
    ProcessExtenalResources: ['script']
  scripts: ['bower_components/ozjs/oz.js']
  done: (errors, window)->
    # unit test with jsdom
    # 'loading is finished'
    {require, define} = window

    require.config({
      baseUrl: './js'
      # distUrl: 'http://static_domain/js/mod'
      aliases: {
        'jquery': '../bower_components/src/'
      }
      enableAutoSuffix: false
    })

    define('sizzle', '../bower_components/sizzle/dist/sizzle.js')
    define('underscore', '../bower_components/underscore/underscore.js')
    define('backbone', '../bower_components/backbone/backbone.js')

    # build a custom jquery as needed
    define('jquery', [
      'jquery/core'
    ], ( jQuery )->
      return jQuery
    )

    # custom build of underscore/lo-dash, will privated in the future
    require ['jquery'], ($)->
      title = 'hfn'
      $('title').html(title)
      console.log document.title == title

}
