module.exports = function(grunt) {

  grunt.initConfig({
    livescript: {
      src: {
        files: {
          'S1/add.js': 'S1/add.ls',
          'S2/add.js': 'S2/add.ls',
          'S3/add.js': 'S3/add.ls',
          'S4/add.js': 'S4/add.ls'
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