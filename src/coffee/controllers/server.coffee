Backbone = require "backbone"

async = require "async"

ServerListView = require "../views/server_list"
ServerFormView = require "../views/server_form"
ServerCollection = require "../collections/server"
ConfigurationCollection = require "../collections/configuration"
AccountCollection = require "../collections/account"
TemplateCollection = require "../collections/template"

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
    "servers/add": "add"
  }

  list: ->

    app.models.menu.set "active", "servers"

    @collection.fetch {
      success: =>
        @views.list.render {@collection}
    }

  add: ->

    app.models.menu.set "active", "servers"

    async.parallel(
      {
        configurations: (taskCallback)->
          new ConfigurationCollection().fetch {
            success: (collection)->
              taskCallback null, collection.toJSON()
            error: ->
              console.log arguments
          }
        accounts: (taskCallback)->
          new AccountCollection().fetch {
            success: (collection)->
              taskCallback null, collection.toJSON()
            error: ->
              console.log arguments

          }
        templates: (taskCallback)->
          new TemplateCollection().fetch {
            success: (collection)->
              taskCallback null, collection.toJSON()
            error: ->
              console.log arguments
          }
      }
      (err, {configurations, accounts, templates})->
        if err
          return alert err
        new ServerFormView().render({configurations, accounts, templates})
    )



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