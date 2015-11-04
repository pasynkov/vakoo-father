class Router


  constructor: (@webServer)->

    @webServer.addRoute "get", "/api/accounts", "account", "list"
    @webServer.addRoute "get", "/api/accounts/:id", "account", "fetch"
    @webServer.addRoute "put", "/api/accounts/:id", "account", "update"
    @webServer.addRoute "post", "/api/accounts", "account", "create"

    @webServer.addRoute "get", "/api/servers", "server", "list"

    @webServer.addRoute "get", "/api/configurations", "server", "configurations"
    @webServer.addRoute "get", "/api/templates", "server", "templates"
    @webServer.addRoute "get", "/api/costs", "server", "costs"
    @webServer.addRoute "post", "/api/servers", "server", "create"


    @webServer.addRoute "options", "*", "account", "pong"

module.exports = Router