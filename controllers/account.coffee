async = require "async"
_ = require "underscore"

Api = require "../scripts/vscale_api"

class AccountController

  constructor: (@context)->

    @context.responser.header "Access-Control-Allow-Origin", "*"
    @context.responser.header "Access-Control-Allow-Headers", "Content-Type"
    @context.responser.header "Access-Control-Allow-Methods", "POST, GET, PUT, DELETE, OPTIONS"

  pong: ->
    @context.sendResult null, "pong"

  list: ->

    vakoo.mysql.collection("accounts").find (err, accounts)=>

      @context.sendResult err, _.map(
        accounts
        (account)->
          account.stopped = Math.round((account.balance + account.bonus_balance) / (account.consuming_hour * 24))
          return account
      )

  fetch: ->

    id = +@context.requester.params.id

    accountObject = null

    async.waterfall(
      [
        async.apply vakoo.mysql.collection("accounts").findOne, {id}
        (account, taskCallback)->
          accountObject = account
          api = new Api {account}
          api.getBalance taskCallback
        (balanceObject, taskCallback)->
          balance = balanceObject.balance / 100
          bonus_balance = balanceObject.bonus / 100

          accountObject.balance = balance
          accountObject.bonus_balance = bonus_balance

          vakoo.mysql.collection("accounts").update {id}, {balance, bonus_balance}, taskCallback

        (..., taskCallback)->

          vakoo.mysql.execute """

            SELECT SUM(t.hour) as hour, SUM(t.month) as month
            FROM (SELECT s.name, c.hour, c.month FROM servers as s
            LEFT JOIN server_costs as c ON s.configuration_id = c.configuration_id
            WHERE s.account_id = #{accountObject.id}) as t

          """, taskCallback

        ([consuming], taskCallback)->

          accountObject.consuming_hour = consuming.hour
          accountObject.consuming_month = consuming.month

          accountObject.stopped = Math.round((accountObject.balance + accountObject.bonus_balance) / (accountObject.consuming_hour * 24))

          vakoo.mysql.collection("accounts").update {id}, {
            consuming_hour: accountObject.consuming_hour
            consuming_month: accountObject.consuming_month
          }, (err)->

            taskCallback err, accountObject


      ]
      @context.sendResult
    )

  create: ->
    vakoo.mysql.collection("accounts").insert _.omit(@context.request.body, "id"), @context.sendResult

  update: ->
    vakoo.mysql.collection("accounts").update(
      {id: +@context.request.body.id}
      _.omit(@context.request.body, "id")
      (err)=>
        @context.sendResult err, @context.request.body
    )

module.exports = AccountController