class AccountController

  constructor: (@context)->

    @context.responser.header "Access-Control-Allow-Origin", "*"

  list: ->

    vakoo.mysql.collection("accounts").find @context.sendResult


module.exports = AccountController