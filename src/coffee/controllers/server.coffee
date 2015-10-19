Backbone = require "backbone"

ServerListView = require "../views/server_list"
ServerCollection = require "../collections/server"

class ServerController extends Backbone.Router

  constructor: ->
    @collection = new ServerCollection
    @views = {
      list: new ServerListView
#      form: new AccountFormView
    }

    super

  routes: {
    "servers": "list"
#    "accounts/:id/refresh": "refresh"
#    "accounts/:id/edit": "form"
#    "accounts/add": "form"
  }

  list: ->
    @collection.fetch {
      success: =>
        @views.list.render {@collection}
    }

#  form: (id)->
#    unless id
#      return new AccountFormView({model: new AccountModel}).render()
#
#    render = (model)->
#      new AccountFormView({model}).render()
#
#    unless (model = @collection.get id)
#      return new AccountModel({id}).fetch {
#        success: render
#      }
#
#    render model


module.exports = ServerController