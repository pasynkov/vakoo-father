Backbone = require "backbone"

class AccountController extends Backbone.Router

  routes: {
    "accounts": "list"
  }

  list: ->
    app.collections.account.fetch {
      success: ->
        app.views.accountList.render()
    }

module.exports = AccountController