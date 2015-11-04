Backbone = require "backbone"
$ = require "jquery"
_ = require "underscore"
async = require "async"

ConfigurationCollection = require "../collections/configuration"

class ServerList extends Backbone.View

  constructor: ->

    @panelClasses =
      started: "success"
      stopped: "default"
      billing: "danger"
      locked: "danger"

    super

  render: ({collection})->

    new ConfigurationCollection().fetch {
      success: (confCollection)=>

        configurations = confCollection.toJSON()

        items = collection.toJSON()

        items = _.map(
          items
          (item)=>
            item.panel_class = @panelClasses[item.status]
            if item.locked
              item.panel_class = @panelClasses.locked

            configuration = _.findWhere(
              configurations
              id: item.configuration_id
            )

            item.config = {
              memory: "#{configuration.memory/1024}Gb"
              cpu: "#{configuration.cpus}"
              ssd: "#{configuration.disk/1024}Gb"
              traffic: "#{configuration.network/1024}Tb"
            }

            return item
        )

        $("#content").html app.templates.server_list {items}
    }





module.exports = ServerList