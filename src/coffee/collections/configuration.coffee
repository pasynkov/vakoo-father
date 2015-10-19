Backbone = require "backbone"

class ConfigurationCollection extends Backbone.Collection

  url: "#{app.apiUrl}configurations"

  constructor: ->
    super

module.exports = ConfigurationCollection