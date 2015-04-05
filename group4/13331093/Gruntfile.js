'use strict';

module.exports = function (grunt) {

  // Time how long tasks take. Can help when optimizing build times
  require('time-grunt')(grunt);
  var path = require('path');
  // Load grunt tasks automatically
  require('load-grunt-tasks')(grunt);

  // Define the configuration for all the tasks
  grunt.initConfig({

    // Project settings
    pkg: grunt.file.readJSON('package.json'),
    // Watches files for changes and runs tasks based on the changed files
    watch: {
      options: {
        livereload: true
      },
      coffee: {
        files: ['**/*.coffee'],
        tasks: ['coffee:compile']
      },
      express: {
        files: ['**/*.*', '!server.js', '!data.js'],
        tasks: [],
        options: {
          livereload: 8001
        }
      }
    },
    express: {
      dev: {
        options: {
          server: path.resolve('server.js'),
          bases: [path.resolve('')],
          livereload: 8001,
          port: 3000
        }
      }
    },
    coffee:{
      compile: {
        options: {
          sourceMap: false,
          bare: true
        },
        files: [{
          expand: true,
          src: 'S*/*.coffee',
          ext: '.js'
        }]
      }
    },
    // Empties js
    clean: {
      js: 'S*/index.js'
    }

  });

  grunt.registerTask('c', 'coffee');
  grunt.registerTask('w', 'watch');
  grunt.registerTask('cl', 'clean');
  grunt.registerTask('server', ['coffee', 'express', 'watch']);
};
