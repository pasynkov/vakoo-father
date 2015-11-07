async = require "async"
_ = require "underscore"

Api = require "../scripts/vscale_api"

class ServerController

  constructor: (@context)->

    @context.responser.header "Access-Control-Allow-Origin", "*"
    @context.responser.header "Access-Control-Allow-Headers", "Content-Type"
    @context.responser.header "Access-Control-Allow-Methods", "POST, GET, PUT, DELETE, OPTIONS"

  list: ->

    async.waterfall(
      [
        vakoo.mysql.collection("servers").find
        (servers, taskCallback)=>

          async.parallel(
            {
              accounts: async.apply(
                vakoo.mysql.collection("accounts").find
                {id: {$in: _.map(servers, (s)->s.account_id)}}
              )
              configurations: async.apply(
                vakoo.mysql.collection("server_configurations").find
                {id: {$in: _.map(servers, (s)->s.configuration_id)}}
              )
              costs: async.apply(
                vakoo.mysql.collection("server_costs").find
                {configuration_id: {$in: _.map(servers, (s)->s.configuration_id)}}
              )
            }
            (err, {accounts, configurations, costs})->
              taskCallback err, {servers, accounts, configurations, costs}
          )

        ({servers, accounts, configurations, costs}, taskCallback)->
          taskCallback null, _.map(
            servers
            (server)->
              server.account = _.findWhere accounts, id: server.account_id
              server.account.balance += server.account.bonus_balance
              server.configuration = _.findWhere configurations, id: server.configuration_id
              server.configuration.cost = _.findWhere costs, configuration_id: server.configuration.id
              server.stopped = server.account.balance / (server.configuration.cost.hour * 24)
              return server
          )
      ]
      @context.sendResult
    )

  create: ->

    async.waterfall(
      [
        async.apply async.parallel, {
          account: async.apply vakoo.mysql.collection("accounts").findOne, {id: +@context.request.body.account}
          configuration: async.apply vakoo.mysql.collection("server_configurations").findOne, {id: +@context.request.body.configuration}
          template: async.apply vakoo.mysql.collection("server_templates").findOne, {id: +@context.request.body.template}
        }
        ({account, configuration, template}, taskCallback)=>
          api = new Api {account}

          api.request ["post", "scalets", {
            make_from: template.name
            rplan: configuration.name
            do_start: true
            name: @context.request.body.name
            hostname: @context.request.body.host
            location: "spb0"
#            keys: [1451]
          }], taskCallback
        (res, taskCallback)->
          console.log res
      ]
      @context.sendResult
    )


  configurations: ->
    vakoo.mysql.collection("server_configurations").find @context.sendResult

  templates: ->
    vakoo.mysql.collection("server_templates").find @context.sendResult

  costs: ->
    vakoo.mysql.collection("server_costs").find @context.sendResult

  getKeys: ->
    vakoo.mysql.collection("ssh_keys").find @context.sendResult


module.exports = ServerController