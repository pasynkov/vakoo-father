gulp = require "gulp"
connect = require "gulp-connect"
hb = require "gulp-hb"
clean = require "gulp-clean"
rename = require "gulp-rename"
sass = require "gulp-ruby-sass"
run = require "run-sequence"
browserify = require "browserify"
coffee = require "gulp-coffee"
coffeelint = require "gulp-coffeelint"
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
    root: "exports"
    noRedeclare: true
    processName: (filePath)->
      return declare.processNameByPath(filePath.replace("src/html/templates/",""))
  })
  .pipe concat("templates.js")
  .pipe wrap('var Handlebars = require("handlebars");\n <%= contents %>')
  .pipe gulp.dest("tmp/js/")


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


gulp.task "coffeeify", ->
  gulp.src("./src/coffee/**/*.coffee")
  .pipe coffeelint()
  .pipe coffeelint.reporter()
  .pipe coffee()
  .pipe gulp.dest "./tmp/js"

gulp.task "application", ->
  browserify({
    entries: [
      "./tmp/js/app.js"
    ]
    extensions: [".js"]
  })
  .transform "debowerify"
  .bundle()
  .pipe(source("app.js"))
  .pipe(gulp.dest("./build/js"))


gulp.task "connect", ->
  connect.server {
    root: "./build"
    fallback: "./build/index.html"
    port: 8101
  }


gulp.task "build", ->
  run "clean", [
    "html"
    "templates"
    "icons"
    "css"
    "coffeeify"
  ], "application"

gulp.task "watch", ->
  gulp.watch "src/**/*",["build"]

gulp.task "default", ["build", "watch", "connect"]