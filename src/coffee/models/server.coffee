Backbone = require "backbone"

class ServerModel extends Backbone.Model

  defaults:
    id: null
    name: ""
    host: ""
    ip: ""
    ctid: 0
    status: "started"
    active: 1
    locked: 0
    configuration_id: 0
    template_id: 0
    account_id: 0


  urlRoot: "#{app.apiUrl}servers"

module.exports = ServerModel