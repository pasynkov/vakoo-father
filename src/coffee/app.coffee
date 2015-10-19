window.jQuery = $ = require "jquery"
window.Handlebars = require "handlebars"
Backbone = require "backbone"
bootstrap = require "bootstrap"
_ = require "underscore"

class App

  constructor: ->
    @templates = require "./templates"

    @apiUrl = "http://localhost:8100/api/"

  initialize: ->

    AccountController = require "./controllers/account"
    ServerController = require "./controllers/server"

    @controllers = {
      account: new AccountController
      server: new ServerController
    }

    return @

window.app = new App
app.initialize()

$(document).ready ->
  Backbone.history.start()