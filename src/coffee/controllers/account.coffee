Backbone = require "backbone"
async = require "async"

AccountModel = require "../models/account"
AccountCollection = require "../collections/account"
AccountListView = require "../views/account_list"
AccountFormView = require "../views/account_form"

class AccountController extends Backbone.Router

  constructor: ->
    @collection = new AccountCollection
    @views = {
      list: new AccountListView
      form: new AccountFormView
    }

    super

  routes: {
    "accounts": "list"
    "accounts/:id/refresh": "refresh"
    "accounts/refresh": "refresh"
    "accounts/:id/edit": "form"
    "accounts/add": "form"
  }

  refresh: (id)->
    if id
      @collection.get(id).refresh =>
        @navigate "accounts", trigger: true
    else
      async.map(
        @collection.models
        (model, done)->
          model.refresh done
        (err)=>
          @navigate "accounts", trigger: true
      )

  list: ->

    app.models.menu.set "active", "accounts"

    @collection.fetch {
      success: =>
        @views.list.render {@collection}
    }

  form: (id)->
    unless id
      return new AccountFormView({model: new AccountModel}).render()

    render = (model)->
      new AccountFormView({model}).render()

    unless (model = @collection.get id)
      return new AccountModel({id}).fetch {
        success: render
      }

    render model


module.exports = AccountController