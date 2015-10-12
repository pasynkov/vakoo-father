Backbone = require "backbone"

class AccountModel extends Backbone.Model

  defaults:
    id: null
    login: ""
    password: ""
    email: ""
    token: ""
    balance: 0
    bonus_balance: 0


module.exports = AccountModel