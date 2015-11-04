Backbone = require "backbone"

class TemplateCollection extends Backbone.Collection

  url: "#{app.apiUrl}templates"

  constructor: ->
    super

module.exports = TemplateCollection