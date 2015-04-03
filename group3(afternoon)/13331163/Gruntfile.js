module.exports = function(grunt) {
  // 获取路径为express服务
  var path = require('path');
  // 自动分析package.json文件，自动加载所找到的grunt模块
  require('load-grunt-tasks')(grunt);

  // 配置任务
  grunt.initConfig({
    // 复制文件
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
      },
      // jQuery: {
      //   expand: true,
      //   cwd: "node_modules/jquery/dist/",
      //   src: "jquery.js",
      //   dest: "S1/bin"
      // }
    },

    // 编译ls文件 并 送到dest
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
        dest: "server.js",
      }
    },

    // 启动服务器
    express: {
      dev: {
        options: {
          // child process for server to run
          // serverreload: true,
          server: path.resolve("server.js"),
          bases: [path.resolve("")],
          hostname: 'localhost',
          port: 3000,
          livereload: 3001
        }
      }
    },

    // 清空bin文件夹和服务器文件
    clean: {
      client: ["S?/bin/**"],
      server: ['server.js']
    },
    
    // 观察文件的变化并且更新调用相应的任务
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

  // 更改delta的名字，连接到grunt-contrib-watch模块，别名是为了更好的区别观察任务和watch指令
  grunt.renameTask("watch", "delta");
  // 注册任务---编译和复制文件-建立项目
  grunt.registerTask("build", ["clean", "livescript", "copy"]);
  // 使所有任务可以根据一个命令有序运行
  grunt.registerTask("watch", ["build", "express", "delta"])
}