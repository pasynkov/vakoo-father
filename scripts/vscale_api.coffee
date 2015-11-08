request = require "request"

class Api

  constructor: ({@account})->

    @logger = vakoo.logger.vscale

    @apiUrl = "https://api.vscale.io/v1/"

    @logger.info "Initialize api with account `#{@account.email}`"


  request: ([method, url, body], callback)=>

    @logger.info "run request `#{method}` to `#{url}`"

    request[method] {
      url: @apiUrl + url
      headers:
        "X-Token": @account.token
      json: body or true
    }, (err, res, body)=>
      unless res.statusCode is 200
        console.log res.toJSON()
        console.log res.request.body
        console.log res.request.toJSON()
        console.log res.statusCode, body
      callback err, body

  getBalance: (callback)=>

    @request ["get", "billing/balance"], callback

  getServerConfigurations: (callback)=>
    @request ["get", "rplans"], callback


module.exports = Api