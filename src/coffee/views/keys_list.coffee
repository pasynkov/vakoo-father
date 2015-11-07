Backbone = require "backbone"
$ = require "jquery"
_ = require "underscore"

class KeysList extends Backbone.View

  render: (collection)->
    $("#content").html app.templates.keys_list items: collection.toJSON()

module.exports = KeysList