window.jQuery = $ = require "jquery"
window.Handlebars = require "handlebars"
Backbone = require "backbone"
bootstrap = require "bootstrap"
_ = require "underscore"


MainController = require "./controllers/main"
AccountController = require "./controllers/account"

AccountCollection = require "./collections/account"

AccountModel = require "./models/account"

AccountView = require "./views/account"
AccountListView = require "./views/account_list"

window.app = app = {
  controllers:
    main: new MainController
    account: new AccountController
  models:
    account: new AccountModel
  collections:
    account: new AccountCollection
  views:
    accountList: new AccountListView
}



Backbone.history.start()