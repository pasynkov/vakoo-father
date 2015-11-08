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

    #todo remove this

    $("#name").val("Test Server")
    $("#host").val("cs1.vakoo.ru")

    $("#configuration [value=#{_.min(data.configurations, (a)->a.memory).id}]").attr("selected", "selected")
    $("#account [value=#{_.max(data.accounts, (a)->a.stopped).id}]").attr("selected", "selected")

  save: (e)->
    e.preventDefault()

    serialized = @$el.serializeArray()

    serialized = _.reject serialized, (i)-> i.name is "keys"

    serialized.push {
      name: "keys"
      value: _.compact _.map(
        @$el.serializeArray()
        (i)->
          if i.name is "keys"
            return i.value
          return false
      )
    }

    attrs = _.object _.map(
      serialized
      (item)-> [item.name, item.value]
    )

    @model.save attrs, {
      success: ->
        app.controllers.server.navigate "servers", trigger: true
      error: ->
        console.error arguments
    }

module.exports = AccountForm