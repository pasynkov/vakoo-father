Backbone = require "backbone"

class AccountModel extends Backbone.Model

  defaults:
    id: null
    login: null
    password: ""
    email: ""
    token: ""
    balance: 0
    bonus_balance: 0

  urlRoot: "#{app.apiUrl}accounts"

  refresh: (callback)=>
    @fetch success: callback

module.exports = AccountModel