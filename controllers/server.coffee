async = require "async"
_ = require "underscore"

class ServerController

  constructor: (@context)->

    @context.responser.header "Access-Control-Allow-Origin", "*"
    @context.responser.header "Access-Control-Allow-Headers", "Content-Type"
    @context.responser.header "Access-Control-Allow-Methods", "POST, GET, PUT, DELETE, OPTIONS"

  list: ->

    vakoo.mysql.collection("servers").find @context.sendResult


  configurations: ->
    vakoo.mysql.collection("server_configurations").find @context.sendResult

  costs: ->
    vakoo.mysql.collection("server_costs").find @context.sendResult


module.exports = ServerController