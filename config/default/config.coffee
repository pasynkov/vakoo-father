config =

  storage:

    enable: true

#    redis:
#      enable: true
#      startupClean: true

#    mongo:
#      name: "vakoo"
#      enable: true

    mysql:
      host: "db.vakoo.ru"
      user: "vakoo"
      password: "085bdb2261"
      database: "vakoo"

  web:
    enable: true
#    static: "static"
#    cacheStatic: true
    port: 8100

#  loggers:
#    routesInitializer: {}
#    cacheInitializer: {}
#    yandex: {}

module.exports = config
