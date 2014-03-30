var gulp = require('gulp');
var mocha = require('gulp-mocha');
var gutil = require('gulp-util');
var coffee = require('gulp-coffee');
var rename = require('gulp-rename');
var uglify = require('gulp-uglify');
var jshint = require('gulp-jshint');
var clean = require('gulp-clean');


var main_coffee_files = './src/*.coffee';
var lib_coffee_files = './src/lib/*.coffee';
var test_coffee_files = './test/*.coffee'

gulp.task('coffee-main', function() {
  gulp.src(main_coffee_files)
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./build/'))
});

gulp.task('coffee-lib', function() {
  gulp.src(lib_coffee_files)
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./build/lib/'))
});

gulp.task('coffee-test', function() {
  gulp.src(test_coffee_files)
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./test/'))
});

gulp.task('clean', function () {
  gulp.src(['./build/', './test/*.js'], {read: false})
    .pipe(clean());
});

gulp.task('deploy', function () {

});

gulp.task('coffee', ['coffee-main', 'coffee-lib', 'coffee-test']);

gulp.task('default', ['clean', 'coffee'])