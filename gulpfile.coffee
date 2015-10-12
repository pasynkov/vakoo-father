gulp = require "gulp"
connect = require "gulp-connect"
hb = require "gulp-hb"
clean = require "gulp-clean"
rename = require "gulp-rename"
sass = require "gulp-ruby-sass"
run = require "run-sequence"
browserify = require "browserify"
source = require "vinyl-source-stream"

handlebars = require "gulp-handlebars"
wrap = require "gulp-wrap"
declare = require "gulp-declare"
concat = require "gulp-concat"

config = {
  sassPath: "./src/sass"
  bowerDir: "./bower_components"
}


gulp.task 'clean', ->
  gulp.src([
    "./build/*.html"
    "./build/"
    "./tmp/"
  ], {read:false})
  .pipe clean()


gulp.task "html", ->
  gulp.src("src/html/*.hbs")
  .pipe(hb({
      partials: "src/html/partials/*.hbs"
    }))
  .pipe rename (path)->
    path.extname = ".html"
  .pipe gulp.dest("build")

gulp.task "templates", ->
  gulp.src "src/html/templates/*.hbs"
  .pipe handlebars({
    handlebars: require "handlebars"
  })
  .pipe wrap('Handlebars.template(<%= contents %>)')
  .pipe declare({
    namespace: "app.templates"
    noRedeclare: true
  })
  .pipe concat("templates.js")
  .pipe gulp.dest("build/js/")


gulp.task "icons", ->
  gulp.src(config.bowerDir + "/font-awesome/fonts/**.*").pipe(gulp.dest("./build/fonts"))

gulp.task "css", ->

  sass(
      config.sassPath + "/style.scss"
    {
      style: "compressed"
      loadPath: [
        "./src/sass"
        config.bowerDir + "/bootstrap-sass/assets/stylesheets"
        config.bowerDir + "/font-awesome/scss"
      ]
    }
  )
  .on "error", sass.logError
  .pipe gulp.dest("./build/css")


gulp.task "coffeify", ->
  gulp.src("./src/coffee/*.coffee")
  .pipe coffeeify()
  .pipe gulp.dest "./tmp/js"

gulp.task "compile-js", ->
  browserify({
    entries: ["./src/coffee/app.coffee"]
    extensions: [".coffee"]
  })
  .transform "coffeeify"
  .transform "debowerify"
  .bundle()
  .pipe(source("app.js"))
  .pipe(gulp.dest("./build/js"))



gulp.task "connect", ->
  connect.server {root: "./build", port: 8101}


gulp.task "build", ->
  run "clean", [
    "html"
    "templates"
    "icons"
    "css"
    "compile-js"
  ]

gulp.task "watch", ->
  gulp.watch "src/**/*",["build"]

gulp.task "default", ["build", "watch", "connect"]