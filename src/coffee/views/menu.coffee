Backbone = require "backbone"
_ = require "underscore"
$ = require "jquery"

class AccountView extends Backbone.View

  el: $("#nav")

  initialize: ->
    @model.bind "change", @render, @

  render: ->
    @$el.html @template @model.toJSON()

module.exports = AccountView