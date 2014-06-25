var gulp        = require("gulp")
var clean       = require("gulp-clean");

var coffee      = require("gulp-coffee");

var mocha       = require("gulp-mocha")

paths = {
  test:   "test/",
  build:  "build/",
  src:    "src/",
  dist:   "lib/"
}

gulp.task("default", ["build"])

gulp.task("clean", function() {
  return gulp.src([paths.build, paths.dist], {read: false})
    .pipe(clean({bare: true}))
})

gulp.task("build", ["clean"], function() {
  return gulp.src(paths.src + "**/*.coffee")
      .pipe(coffee())
      .pipe(gulp.dest(paths.dist));
})

gulp.task("test", function() {
  require("coffee-script/register");

  return gulp.src("test/**/*.test.coffee")
    .pipe(mocha({
      reporters: "list"
    }))
})
