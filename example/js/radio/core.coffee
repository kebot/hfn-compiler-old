# Radio Core

define [
  'backbone'
], (Backbone)->

  class Song extends Backbone.Model

  class PlayerConfig extends Backbone.Model

  class RadioCore
    """ Messages: 
    switch_song: (new_song, old_song)
    """
    constructor:  ->
      


