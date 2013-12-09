# This file contains the basic configure and interface of this app.
{require, define} = window

require.config({
  baseUrl: './js/'
  # distUrl: 'http://static_domain/js/mod'
  aliases: {
    'jquery': '../bower_components/jquery/src/'
  }
  enableAutoSuffix: false
})

define('sizzle', '../bower_components/sizzle/dist/sizzle.js')
#define('react', '../bower_components/react/react.js')
#define('underscore', '../bower_components/underscore/underscore.js')
#define('backbone', '../bower_components/backbone/backbone.js')

define('react', [], -> return window.React)

###
define('absurd-src', '../bower_components/absurd/client-side/build/absurd.js')
define('absurd', ['absurd-src'], ->
  return Absurd()
)
###

require(['jquery/jquery'], (jQuery)->
  console.log jQuery
)

# custom build of underscore/lo-dash, will privated in the future

# Now let's create some web-components

require ['react'], (React)->
  {div, span} = React.DOM
  CircleProgress = React.createClass({
    getInitialState: ->
      progress: 67

    componentDidMount: ->
      setInterval =>
        if @state.progress > 99
          @progress(0)
        else
          @progress(@state.progress + 1)
      , 100

    progress: (pos)->
      @setState {progress: pos}

    render: ->
      (div {className: if this.state.progress > 50 then 'progress-pie-chart gt-50' else 'progress-pie-chart'}, [
        (div {className: 'ppc-progress'}, [
          (div
            className: 'ppc-progress-fill',
            style:
              '-webkit-transform': "rotate(#{this.state.progress * 360 / 100}deg)"
          )
        ])
        (div {className: 'ppc-percents'}, [
          (div {className: 'pcc-percents-wrapper'}, [
            (span {}, ["#{@state.progress}%"])
          ])
        ])
      ])
  })

  React.renderComponent (CircleProgress {}), document.body


