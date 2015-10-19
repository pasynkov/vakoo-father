Backbone = require "backbone"

AccountModel = require "../models/account"

class AccountCollection extends Backbone.Collection

  model: AccountModel
  url: "#{app.apiUrl}accounts"

module.exports = AccountCollection