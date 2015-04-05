module.exports = function(grunt) {
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
        watch: {
            client: {
                files: ['src/**/*.html', 'src/**/*.css', 'src/**/*.js'],
                options: {
                    livereload: true
                }
            }
        },
        livescript: {
            client: {
                expand: true,
                src: ['src/**/*.ls', 'src/server.ls'],
                ext: '.js'
            }
        }
	})
	grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-livescript');
	grunt.registerTask('default', ['livescript', 'watch']);
}