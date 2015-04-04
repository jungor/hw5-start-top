var gulp = require('gulp');
var jade = require('gulp-jade');
var livescript = require('gulp-livescript');
    
var paths = ['.', 'S1', 'S2', 'S3', 'S4'];

gulp.task('default', function() {
    paths.forEach(function(path) {
        gulp.src(path + '/*.jade')
            .pipe(jade())
            .pipe(gulp.dest(path))
        gulp.src(path + '/*.ls')
            .pipe(livescript())
            .pipe(gulp.dest(path))
    });
});
