class Router


  constructor: (@webServer)->

    @webServer.addRoute "get", "/api/accounts", "account", "list"

module.exports = Router