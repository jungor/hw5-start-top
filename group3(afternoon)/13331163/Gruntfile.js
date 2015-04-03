module.exports = function(grunt) {

  // 自动分析package.json文件，自动加载所找到的grunt模块
  require('load-grunt-tasks')(grunt);

  grunt.initConfig({
    copy: {
      S1: {
        expand: true,
        cwd: "S1/src/",
        src: ["**/**.**", "!*.ls"],
        dest: "S1/bin"
      },
      S2: {
        expand: true,
        cwd: "S2/src/",
        src: ["**/**.**", "!*.ls"],
        dest: "S2/bin"
      },
      S3: {
        expand: true,
        cwd: "S3/src/",
        src: ["**/**.**", "!*.ls"],
        dest: "S3/bin"
      },
      S4: {
        expand: true,
        cwd: "S4/src/",
        src: ["**/**.**", "!*.ls"],
        dest: "S4/bin"
      },
      S5: {
        expand: true,
        cwd: "S5/src/",
        src: ["**/**.**", "!*.ls"],
        dest: "S5/bin"
      }

    },

    livescript: {
      clientS1: {
        expand: true,
        cwd: "S1/src/",
        src: "*.ls",
        dest: "S1/bin/",
        ext: ".js"
      },
      
      clientS2: {
        expand: true,
        cwd: "S2/src/",
        src: "*.ls",
        dest: "S2/bin/",
        ext: ".js"
      },
      
      clientS3: {
        expand: true,
        cwd: "S3/src/",
        src: "*.ls",
        dest: "S3/bin/",
        ext: ".js"
      },
      
      clientS4: {
        expand: true,
        cwd: "S4/src/",
        src: "*.ls",
        dest: "S4/bin/",
        ext: ".js"
      },
      
      clientS5: {
        expand: true,
        cwd: "S5/src/",
        src: "*.ls",
        dest: "S5/bin/",
        ext: ".js"
      },
      server: {
        expand: false,
        src: ["server/src/server.ls"],
        dest: "server/bin/server.js",
      }
    },

    express: {
      server: {
        options: {
          // child process for server to run
          serverreload: true,
          hostname: 'localhost',
          port: 3000,
          bases: 'server/bin/server.js'
        }
      }
    },

    clean: {
      client: ["S?/bin/**"],
      server: ['server/bin/**/*.js']
    },
    
    delta: {
      options: {
        livereload: true
      },

      S1: {
        files: ["S1/src/**/**.**", "!S1/src/**/*.ls"],
        tasks: ["newer:copy:S1"]
      },
      livescriptS1: {
        files: ["S1/src/**/*.ls"],
        tasks: ["newer:livescript:clientS1"]
      },
      S2: {
        files: ["S2/src/**/**.**", "!S2/src/**/*.ls"],
        tasks: ["newer:copy:S2"]
      },
      livescriptS2: {
        files: ["S2/src/**/*.ls"],
        tasks: ["newer:livescript:clientS2"]
      },
      S3: {
        files: ["S3/src/**/**.**", "!S3/src/**/*.ls"],
        tasks: ["newer:copy:S3"]
      },
      livescriptS3: {
        files: ["S3/src/**/*.ls"],
        tasks: ["newer:livescript:clientS3"]
      },
      S4: {
        files: ["S4/src/**/**.**", "!S4/src/**/*.ls"],
        tasks: ["newer:copy:S4"]
      },
      livescriptS4: {
        files: ["S4/src/**/*.ls"],
        tasks: ["newer:livescript:clientS4"]
      },
      S5: {
        files: ["S5/src/**/**.**", "!S5/src/**/*.ls"],
        tasks: ["newer:copy:S5"]
      },
      livescriptS5: {
        files: ["S5/src/**/*.ls"],
        tasks: ["newer:livescript:clientS5"]
      }
    }
  });

  grunt.renameTask("watch", "delta");
  grunt.registerTask("build", ["livescript", "copy"]);
  grunt.registerTask("watch", ["build", "express", "delta"])
}