Backbone = require "backbone"

class KeyModel extends Backbone.Model

  defaults:
    id: null
    name: ""
    value: ""

  urlRoot: "#{app.apiUrl}servers/keys"

module.exports = KeyModel