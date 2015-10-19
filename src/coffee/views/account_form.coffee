Backbone = require "backbone"
$ = require "jquery"
_ = require "underscore"

AccountModel = require "../models/account"

class AccountForm extends Backbone.View

  id: "account-form"
  className: "form-horizontal"
  tagName: "form"

  model: new AccountModel

  events:
    "submit": "save"

  flush: ->
    @model = new AccountModel

  render: ->
    $("#content").empty().append(
      @$el.html app.templates.account_form @model.toJSON()
    )
    @delegateEvents()

  save: (e)->
    e.preventDefault()

    attrs = _.object _.map(
      @$el.serializeArray()
      (item)-> [item.name, item.value]
    )

    unless attrs.id
      attrs.id = null

    @model.save attrs, {
      success: ->
        app.controllers.account.navigate "accounts", trigger: true
    }

module.exports = AccountForm