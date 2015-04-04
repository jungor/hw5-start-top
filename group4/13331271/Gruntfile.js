module.exports = function(grunt) {
  var path, pkg;
  require('load-grunt-tasks')(grunt);
  path = require('path');
  pkg = grunt.file.readJSON("package.json");
  grunt.initConfig({
    pkg: pkg,
    clean: {
      all: {
        dot: true,
        files: {
          src: ["S1/index.js", "S2/index.js", "S3/index.js", "S4/index.js", "S5/index.js", "server.js"]
        }
      }
    },
    livescript: {
      options: {
        bare: false
      },
      index: {
        options: {
          bare: false
        },
        expand: true,
        src: ["S1/index.ls", "S2/index.ls", "S3/index.ls", "S4/index.ls", "S5/index.ls"],
        ext: ".js"
      },
      server: {
        expand: true,
        src: ["server.ls", "!host-config.example.ls"],
        ext: ".js"
      }
    },
    express: {
      dev: {
        options: {
          server: path.resolve('server.js'),
          bases: [path.resolve('')],
          livereload: 8001,
          port: 8000
        }
      }
    },
    delta: {
      options: {
        livereload: true
      },
      livescriptindex: {
        files: ["S1/index.ls", "S2/index.ls", "S3/index.ls", "S4/index.ls", "S5/index.ls"],
        tasks: ["livescript:index"]
      },
      livescriptserver: {
        files: ["server.ls"],
        tasks: ["newer:livescript:server", "express-restart"],
        options: {
          livereload: false
        }
      },
      express: {
        files: ["**/*.*", "!server.js", "!data.js"],
        tasks: [],
        options: {
          livereload: 8001
        }
      }
    }
  });
  grunt.renameTask("watch", "delta");
  grunt.registerTask("watch", ["build", "express", "delta"]);
  grunt.registerTask("default", ["build"]);
  grunt.registerTask("build", ["clean", "livescript"]);
};