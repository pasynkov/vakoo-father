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

    vakoo.mysql.collection("accounts").find @context.sendResult

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
          taskCallback null, accountObject
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