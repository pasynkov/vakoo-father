Backbone = require "backbone"
$ = require "jquery"
_ = require "underscore"

ServerModel = require "../models/server"

class AccountForm extends Backbone.View

  id: "account-form"
  className: "form-horizontal"
  tagName: "form"

  model: new ServerModel

  events:
    "submit": "save"

  flush: ->
    @model = new AccountModel

  render: (data)->
    $("#content").empty().append(
      @$el.html app.templates.server_form data
    )
    @delegateEvents()

  save: (e)->
    e.preventDefault()

    attrs = _.object _.map(
      @$el.serializeArray()
      (item)-> [item.name, item.value]
    )

    @model.save attrs, {
      success: ->
        app.controllers.server.navigate "servers", trigger: true
      error: ->
        alert "error"
        console.error arguments
    }

module.exports = AccountForm