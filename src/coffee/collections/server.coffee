Backbone = require "backbone"

ServerModel = require "../models/server"

class ServerCollection extends Backbone.Collection

  model: ServerModel
  url: "#{app.apiUrl}servers"

module.exports = ServerCollection