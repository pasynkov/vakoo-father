Backbone = require "backbone"

class MainController extends Backbone.Router

  routes: {
    "": "index"
    "dashboard": "dashboard"
  }

  index: ->
    console.log "index"

  dashboard: ->
    console.log "dashboard"

module.exports = MainController