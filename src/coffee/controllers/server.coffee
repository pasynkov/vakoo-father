Backbone = require "backbone"

async = require "async"

ServerListView = require "../views/server_list"
ServerFormView = require "../views/server_form"
KeysView = require "../views/keys"

ServerCollection = require "../collections/server"
ConfigurationCollection = require "../collections/configuration"
AccountCollection = require "../collections/account"
TemplateCollection = require "../collections/template"
KeysCollection = require "../collections/key"

class ServerController extends Backbone.Router

  constructor: ->
    @collection = new ServerCollection
    @views = {
      list: new ServerListView
      keys: new KeysView
#      form: new AccountFormView
    }

    super

  routes: {
    "servers": "list"
    "servers/add": "add"
    "servers/keys": "keysList"
    "servers/keys/add": "keysAdd"
    "servers/keys/:id/remove": "keysRemove"
  }

  subMenuOptions: (active)->



    {
      title: do ->
        active[0].toUpperCase() + active[1...]
      items: [
        {
          title: "Servers"
          route: "servers"
          active: active is "servers"
        }
        {
          title: "SSH Keys"
          route: "servers/keys"
          active: active is "servers/keys"
        }
      ]
      controls: do ->

        result = []

        switch active
          when "servers" then do ->
            result = [{"servers/add": "plus"}]
          when "servers/keys" then do ->
            result = [{"servers/keys/add": "plus"}]
        return result
    }

  navigate: (fragment, options)->
    console.log fragment, options
    super fragment, options

  list: ->

    app.models.menu.set {
      active: "servers"
      hideSub: false
    }

    app.models.menu.subMenu.set @subMenuOptions "servers"

    @collection.fetch {
      success: =>
        @views.list.render {@collection}
    }

  keysList: ->

    app.models.menu.set {
      active: "servers"
      hideSub: false
    }

    app.models.menu.subMenu.set @subMenuOptions "servers/keys"

    new KeysCollection().fetch {
      success: @views.keys.render
      error: ->
        console.log "error"
    }

  keysAdd: ->

    app.models.menu.set {
      active: "servers"
      hideSub: false
    }

    app.models.menu.subMenu.set @subMenuOptions "servers/keys"

    @views.keys.renderForm()

  keysRemove: (id)->

    new KeysCollection().fetch {
      success: (collection)=>
        collection.get(id).destroy {
          wait: true
          success: =>
            @navigate "servers/keys", {trigger: true}
          error: ->
            console.log "error"
        }
      error: ->
        console.log "error"
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