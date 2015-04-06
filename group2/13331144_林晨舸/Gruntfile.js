module.exports = function(grunt) {

  grunt.initConfig({
    livescript: {
      src: {
        files: {
          'S1/index.js': 'S1/index.ls',
          'S2/index.js': 'S2/index.ls',
          'S3/index.js': 'S3/index.ls',
          'S4/index.js': 'S4/index.ls'
        }
      }
    },
    watch: {
      livescript: {
        files: ['**/*.ls'],
        tasks: ['livescript'],
        options: {
          livereload: true
        }
      }
    }
  });

  require('load-grunt-tasks')(grunt);

  grunt.registerTask('default', ['livescript', 'watch']);

};