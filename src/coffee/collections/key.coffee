Backbone = require "backbone"

KeyModel = require "../models/key"

class KeyCollection extends Backbone.Collection

  model: KeyModel
  url: "#{app.apiUrl}servers/keys"

module.exports = KeyCollection