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

    MenuModel = require "./models/menu"

    MenuView = require "./views/menu"

    @controllers = {
      native: new Backbone.Router
      account: new AccountController
      server: new ServerController
    }

    @models = {
      menu: new MenuModel
    }

    @views = {
      menu: new MenuView {model: @models.menu}
    }

    @models.menu.trigger "change"

    @initClicks()

    return @

  initClicks: =>
    $(document).on "click", "a[href^='/']", (event)=>
      href = $(event.currentTarget).attr "href"
      passThrough = href.indexOf('sign_out') >= 0
      if not event.altKey and not event.ctrlKey and not event.metaKey and not event.shiftKey
        event.preventDefault()
        url = href.replace(/^\//,'').replace('\#\!\/','')
        @controllers.native.navigate url, {trigger: true}
        return false
      return true

window.app = new App
app.initialize()

$(document).ready ->
  Backbone.history.start(pushState: true)