Backbone = require "backbone"
$ = require "jquery"
_ = require "underscore"

class AccountList extends Backbone.View

#  el: $("#account-list")

  render: ({collection})->
    $("#content").html app.templates.account_list items: collection.toJSON()

module.exports = AccountList