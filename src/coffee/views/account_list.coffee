Backbone = require "backbone"
$ = require "jquery"
_ = require "underscore"

class AccountList extends Backbone.View

  el: $("#account-list")

  render: ->
    @$el.html app.templates.account_list items: app.collections.account.toJSON()

module.exports = AccountList