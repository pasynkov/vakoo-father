Backbone = require "backbone"
_ = require "underscore"
$ = require "jquery"

class MenuView extends Backbone.View

  el: $("#nav-container")

  template: app.templates.menu
  subTemplate: app.templates.sub_menu

  initialize: ->

    @model.bind "change", @render, @
    @model.subMenu.bind "change", @renderSub, @


  render: (opts)->

    data = @model.toJSON()

    for item in data.items
      item.active = if item.route is data.active then true else false

    $("title").text(
      _.compact([_.findWhere(data.items, active: true)?.title, "Vakoo"]).join(" -- ")
    )

    @$el.html @template @model.toJSON()

  renderSub: ->

    $("#sub-nav-container").empty()

    if @model.subMenu.get "hide"
      return

    data = @model.subMenu.toJSON()

    $("#sub-nav-container").html(
      @subTemplate data
    )


module.exports = MenuView