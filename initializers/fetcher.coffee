
Api = require "../scripts/api"
async = require "async"
_ = require "underscore"


class FetcherInitializer

  constructor: (callback)->

    async.waterfall(
      [
        vakoo.mysql.collection("accounts").findOne
        (account, taskCallback)=>
          @api = new Api {account}

          async.parallel {
            plans: @api.getServerConfigurations
            prices: async.apply @api.request, ["get", "billing/prices"]
            locations: async.apply @api.request, ["get", "locations"]
            images: async.apply @api.request, ["get", "images"]
          }, taskCallback

        ({plans, prices, locations, images}, taskCallback)=>


          async.series [
            async.apply @syncConfigurations, plans
            async.apply @syncCosts, prices
            async.apply @syncTemplates, images
          ], taskCallback

        (..., taskCallback)=>

          vakoo.mysql.collection("accounts").find taskCallback

        (accounts, taskCallback)=>
          async.map(
            accounts
            @syncServers
            taskCallback
          )

      ]
      callback
    )

  syncServers: (account, callback)=>
    api = new Api {account}
    async.waterfall(
      [
        async.apply async.parallel, {
          scalets: async.apply api.request, ["get", "scalets"]
          configurations: vakoo.mysql.collection("server_configurations").find
          templates: vakoo.mysql.collection("server_templates").find
        }
        ({scalets, configurations, templates}, taskCallback)=>

          async.map(
            scalets
            (scalet, done)->
              vakoo.mysql.collection("servers").insert {
                configuration_id: _.findWhere(configurations, {name: scalet.rplan}).id
                template_id: _.findWhere(templates, {name: scalet.made_from}).id
                account_id: account.id
                host: scalet.hostname
                ip: scalet.public_address.address
                ctid: scalet.ctid
                status: scalet.status
                locked: +scalet.locked
                active: +scalet.active
                name: scalet.name
              }, {updateOnDuplicate: {set: [
                "host"
                "locked"
                "active"
                "status"
                "configuration_id"
                "template_id"
                "name"
              ]}}, done
            taskCallback
          )
      ]
      callback
    )

  syncTemplates: (images, callback)=>

    async.waterfall(
      [
        vakoo.mysql.collection("server_configurations").find
        (configurations, taskCallback)->
          async.map(
            images
            (image, done)->
              vakoo.mysql.collection("server_templates").insert {
                name: image.id
                size: image.size
              }, {updateOnDuplicate: {set: ["size"]}}, (err)->
                if err
                  return done err

                vakoo.mysql.collection("server_templates").findOne {name: image.id}, (err, template)->
                  if err
                    return done err

                  insertObjects = _.map(
                    _.filter configurations, (server)-> server.name in image.rplans
                    (s)->
                      {
                        template_id: template.id
                        configuration_id: s.id
                      }
                  )

                  vakoo.mysql.collection("server_templates_available").insert(
                    insertObjects
                    {updateOnDuplicate: {ignore: "configuration_id"}}
                    done
                  )

            taskCallback
          )
      ]
      callback
    )



  syncCosts: (prices, callback)=>

    async.waterfall(
      [
        vakoo.mysql.collection("server_configurations").find
        (configurations, taskCallback)->

          async.map(
            _.pairs prices.default
            ([name, price], done)->

              server = _.find configurations, {name}
              unless server
                return done()

              vakoo.mysql.collection("server_costs").insert {
                configuration_id: server.id
                hour: price.hour / 100
                month: price.month / 100
              }, {updateOnDuplicate: {set: ["hour", "month"]}}, done

            taskCallback
          )
      ]
      callback
    )

  syncConfigurations: (plans, callback)=>

    async.map(
      plans
      (plan, done)->
        vakoo.mysql.collection("server_configurations").insert {
          name: plan.id
          cpus: plan.cpus
          memory: plan.memory
          disk: plan.disk
          network: plan.network
          ips: plan.addresses
        }, {updateOnDuplicate: {set: ["cpus", "memory", "disk", "network", "ips"]}}, done

      callback
    )


module.exports = FetcherInitializer