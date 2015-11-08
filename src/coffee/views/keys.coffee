Backbone = require "backbone"
$ = require "jquery"
_ = require "underscore"

KeyModel = require "../models/key"

class KeysView extends Backbone.View

  render: (collection)->
    $("#content").html app.templates.keys {
      data:
        items: collection.toJSON()
      list: true
    }

  renderForm: ->

    $("#content").html app.templates.keys()

    $("#key-form").submit (e)->
      e.preventDefault()

      new KeyModel().save {
        name: $("#key-form [name=name]").val()
        value: $("#key-form [name=value]").val()
      }, {
        success: ->
          app.controllers.server.navigate "servers/keys", {trigger: true}
        error: ->
          console.log "error"
      }

module.exports = KeysView