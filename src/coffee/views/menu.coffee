Backbone = require "backbone"
_ = require "underscore"
$ = require "jquery"

class AccountView extends Backbone.View

  el: $("#nav-container")

  template: app.templates.menu

  initialize: ->
    @model.bind "change", @render, @

  render: ->
    data = @model.toJSON()

    for item in data.items
      item.active = if item.route is data.active then true else false

    $("title").text(
      [_.findWhere(data.items, active: true)?.title, "Vakoo"].join(" -- ")
    )

    @$el.html @template @model.toJSON()

module.exports = AccountView