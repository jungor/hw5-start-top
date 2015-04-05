var exec = require('child_process').exec;

var gulp = require('gulp');
var jade = require('gulp-jade');
var livescript = require('gulp-livescript');
    
var paths = ['S1', 'S2', 'S3', 'S4', 'S5'];

// completely compile
gulp.task('compile', function() {
    paths.forEach(function(path) {
        gulp.src(path + '/*.jade')
            .pipe(jade())
            .pipe(gulp.dest(path));
        gulp.src(path + '/*.ls')
            .pipe(livescript())
            .pipe(gulp.dest(path));
    });
    gulp.src('server.ls')
        .pipe(livescript())
        .pipe(gulp.dest('.'));
});

// watch *.js and *.ls and recompile when changed
gulp.task('watch', function() {
    paths.forEach(function(path) {
        gulp.watch(path + '/*.jade', function(evt) {
            var filepath = evt.path;
            gulp.src(filepath)
                .pipe(jade())
                .pipe(gulp.dest(path));
        });
        gulp.watch(path + '/*.ls', function(evt) {
            var filepath = evt.path;
            gulp.src(filepath)
                .pipe(livescript())
                .pipe(gulp.dest(path));
        });
    });
    gulp.watch('server.ls', function(evt) {
        gulp.src('server.ls')
            .pipe(livescript())
            .pipe('.');
    });
});

// start server
gulp.task('start', function() {
    exec('node server.js');
});

// clear *.js and *.html
gulp.task('clear', function() {
    fileList = ['server.js'];
    paths.forEach(function(path) {
        fileList.push(path + '/*.js');
        fileList.push(path + '/*.html');
    });
    exec('rm ' + fileList.join(' '));
    console.log(fileList.join(' '));
});
