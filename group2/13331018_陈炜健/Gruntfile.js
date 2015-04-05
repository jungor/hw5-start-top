module.exports = function(grunt) {
  var path = require("path");

  // 配置Grunt各种模块的参数
  grunt.initConfig({
    jshint: { /* jshint的参数 */
        options: {
        eqeqeq: true,
        trailing: true
        },
        files: ["Gruntfile.js", "lib/**/*.js"]
    },
    concat: { /* concat的参数 */
        js: {
          src: ["lib/module1.js", "lib/module2.js", "lib/plugin.js"],
          dest: "dist/script.js"
        },
        css: {
          src: ["style/normalize.css", "style/base.css", "style/theme.css"],
          dest: "dist/screen.css"
        }
    },
    watch: { /* watch的参数 */
        ls: {
          files: "**/*.ls",
          tasks: "livescript",
          options: {
            livereload: true
          }
        },
        js: {
          files: "**/*.js",
          tasks: "jshint",
          options: {
            livereload: true
          }
        },
        css: {
          files: "**/*.css",
          tasks: "jshint",
          options: {
            livereload: true
          }
        },
        html: {
          files: "**/*.html",
          tasks: "jshint",
          options: {
            livereload: true
          }
        }
    },

    express: {
      options: {
        // Override defaults here
      },
      dev: {
        options: {
          script: "server.js",
        }
      }
    },

    livescript: {
      options: {
        bare: false,
      },
      S1: {
        expand: true,
        cwd: "S1/",
        src: ["index.ls"],
        dest: "S1/",
        ext: ".js"
      },
      S2: {
        expand: true,
        cwd: "S2/",
        src: ["index.ls"],
        dest: "S2/",
        ext: ".js"
      },
      S3: {
        expand: true,
        cwd: "S3/",
        src: ["index.ls"],
        dest: "S3/",
        ext: ".js"
      },
      S4: {
        expand: true,
        cwd: "S4/",
        src: ["index.ls"],
        dest: "S4/",
        ext: ".js"
      }
    }
  });

  // 从node_modules目录加载模块文件
  require("load-grunt-tasks")(grunt);

  // 每行registerTask定义一个任务
  grunt.registerTask("default", ["jshint", "concat"]);
  grunt.registerTask("check", ["jshint"]);
  grunt.registerTask("live", ["express", "livescript", "watch"]);

};