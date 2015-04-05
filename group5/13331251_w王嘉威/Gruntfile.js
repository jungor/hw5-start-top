

module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    livescript: {   
      src: {
        files: [
		  {
            expand: true,
			cwd: 'views/',
			src: ['**/*.ls'],
			dest: 'views/',
			ext: '.js',
          },
		],
      },
    },
    sass: {
        dist: {
            files: [
              {
                expand: true,
                cwd: 'views/',
                src: ['**/*.scss'],
                dest: 'views',
                ext: '.css',
              },
            ],
        },
    },
    watch: {
      scripts: {
        files: ['views/**/*.ls', 'views/**/*.scss'],
        tasks: ['livescript', 'sass'],
        options: {
          spawn: false,
        }
      }
    },
	browserSync: {
	  dev: {
        bsFiles: {
          src: 'views/**/*'
		},
		options: {
		  proxy: 'localhost:3000',
		  watchTask: true
		}
	  }
	}
  });

  grunt.loadNpmTasks('grunt-livescript');  
  grunt.loadNpmTasks('grunt-browser-sync');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-sass');

  grunt.registerTask('default', ['browserSync', 'watch']);

};
