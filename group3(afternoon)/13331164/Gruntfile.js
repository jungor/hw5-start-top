'use strict';

module.exports = function (grunt) {
  require('load-grunt-tasks')(grunt);
  var path = require('path');
  require('time-grunt')(grunt);

  grunt.initConfig({

  	copy: {
  		files: {
  			src: ["**/*.*", "!**/*.{jade,ls,sass}"],
  			dest: "bin/",
  			cwd: "src/",
  			expand: true
  		}
  	},

  	clean: {
  		files: {
  			src: ["bin/*"]
  		}
  	},

  	livescript: {
      options: {
        bare: false
      },
      client: {
        expand: true,
        cwd: "src/",
        src: ["**/*.ls"],
        dest: "bin/",
        ext: ".js"
      },
      server: {
        expand: true,
        cwd: "server/",
        src: ["**/*.ls", "!host-config.example.ls"],
        dest: "bin/",
        ext: ".js"
      }
    },

  	express: {
  		dev: {
  			options: {
  				server: path.resolve('bin/server.js'),
          bases: [path.resolve('bin')],
          livereload: 3001,
          port: 3000
  			}
  		}
  	},

  	delta: {
  		options: {
  			livereload: true
  		},
  		livescriptclient: {
        files: ["src/**/*.ls", "!src/at-plus-page/index.ls"],
        tasks: ["newer:livescript:client"]
      },
      livescriptserver: {
        files: ["server/**/*.ls"],
        tasks: ["newer:livescript:server", "express-restart"],
        options: {
          livereload: false
        }
      },
      assests: {
        files: ["src/*", "src/**/*", "!**/*.{jade,ls,sass}"],
        tasks: ["newer:copy"]
      },
  		express: {
  			files: ["bin/**/*.*", "!bin/server.js", "!bin/data.js"],
        tasks: [],
        options: {
          livereload: 3001
        }
  		}
  	}
  });

  grunt.renameTask("watch", "delta");
  grunt.registerTask("watch", ["build", "express", "delta"]);
  grunt.registerTask("default", ["build"]);
  return grunt.registerTask("build", ["clean", "copy", "livescript"]);
}