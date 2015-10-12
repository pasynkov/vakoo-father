Backbone = require "backbone"
_ = require "underscore"
$ = require "jquery"

AccountModel = require "../models/account"

class AccountView extends Backbone.View

  el: $("#account")

  model: new AccountModel

  template: _.template($("#account_list").html())

  render: ->
    @$el.html @template @model.toJSON()

module.exports = AccountView