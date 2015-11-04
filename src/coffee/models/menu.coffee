Backbone = require "backbone"
_ = require "underscore"

class MenuModel extends Backbone.Model

  defaults:
    user: {}
    items: [
      {
        route: "dashboard"
        title: "Dashboard"
      }
      {
        route: "servers"
        title: "Servers"
      }
      {
        route: "accounts"
        title: "Accounts"
      }
    ]
    active: null


module.exports = MenuModel