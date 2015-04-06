module.exports = function(grunt) {
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),

		clean: {
			all: {
				dot: true,
				files: {
					src: ['bin/*']
				} 
			}
		},

		copy: {
			main: {
				expand: true,
				cwd: 'src/',
				src: ['**/*'],
				dest: 'bin/'
			}
		},

		livescript: {
			main: {
				expand: true,
				cwd: 'src/',
				src: '**/*.ls',
				dest: 'bin/',
				ext: '.js'
			}
		},

		watch: {
		 scripts: {
			files: ['src/**/*.ls', 'src/**/*.css', 'src/**/*.html'],
			tasks: ['clean', 'copy', 'livescript'],
			options: {
				livereload: true,
			}
		 }
		},
	});

	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-contrib-clean');
	grunt.loadNpmTasks('grunt-contrib-copy');
	grunt.loadNpmTasks('grunt-livescript');

	grunt.registerTask('default', ['clean', 'copy', 'livescript']);
}