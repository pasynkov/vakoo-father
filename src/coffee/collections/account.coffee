Backbone = require "backbone"

AccountModel = require "../models/account"

class AccountCollection extends Backbone.Collection

  model: AccountModel
  url: "http://localhost:8100/api/accounts"

module.exports = AccountCollection