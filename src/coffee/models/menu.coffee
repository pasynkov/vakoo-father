Backbone = require "backbone"
_ = require "underscore"

class SubMenuModel extends Backbone.Model

  defaults:
    title: ""
    items: []
    controls: []
    hide: false

  set: (name, value)->

    #todo pochinit' eto govno
    if _.isObject name
      unless name?.hide
        name.hide = false

    super name, value

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
    hideSub: true

  subMenu: new SubMenuModel

  set: (name, value)->
    #todo pochinit' eto govno
    if _.isObject name
      unless name.hideSub?
        name.hideSub = true
        @subMenu.set "hide", true
    else if name isnt "hideSub"
      super "hideSub", true
      @subMenu.set "hide", true
    super name, value


module.exports = MenuModel