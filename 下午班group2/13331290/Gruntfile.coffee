module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)
  path = require('path')
  pkg = grunt.file.readJSON("package.json")
  DEBUG = false # 添加测试所需代码，发布时应该为false

  grunt.initConfig 
    pkg: pkg
    meta:
      banner: "/**\n" + " * <%= pkg.name %> - v<%= pkg.version %> - <%= grunt.template.today(\"yyyy-mm-dd\") %>\n" + " * <%= pkg.homepage %>\n" + " *\n" + " * Copyright (c) <%= grunt.template.today(\"yyyy\") %> <%= pkg.author %>\n" + " * Licensed <%= pkg.licenses.type %> <<%= pkg.licenses.url %>>\n" + " */\n"

    clean: 
      all:
        dot: true
        files:
          src: ["bin/*"]

    copy:
      build_app_assets:
        files: [
          src: ["S*/assets/**/*.*", "S*/*.js", "!S*/*.{jade,ls,sass}"]
          dest: "bin/"
          cwd: ""
          expand: true
        ]

    jade:
      options:
        pretty: true
        data: 
          debug: DEBUG
          pkg: pkg
      index:
        expand: true
        cwd: ""
        src: ["S*/*.jade"]
        dest: "bin/"
        ext: ".html"

    sass:
      options:
        includePaths: require('node-bourbon').with('src/common/sass')
      build:
        files: [
          expand: true
          cwd: ""
          src: ["S*/*.sass"]
          dest: "bin/"
          ext: ".css"
        ]

    livescript:
      options:
        livereload: true
      client:
        expand: true
        cwd: ""
        src: ["S*/*.ls"]
        dest: "bin/"
        ext: ".js"
      server:
        expand: true
        cwd: ""
        src: "*.ls"
        dest: "bin/"
        ext: ".js"

    express:
      dev:
        options:
          server: path.resolve('bin/server.js')
          bases: [path.resolve('bin')]
          livereload: 8001
          # serverreload: true
          port: 8000

    delta:
      options:
        livereload: true

      jade:
        files: ["S*/*.jade"]
        tasks: ["jade"]

      livescriptclient:
        files: [ "S*/*.ls"]
        tasks: ["newer:livescript:client"]

      livescriptserver:
        files: ["server.ls"]
        tasks: ["newer:livescript:server", "express-restart"]
        options:
          livereload: false

      sass_src:
        files: ["S*/*.sass"]
        tasks: [
          "sass:build"
        ]

      assets:
        files: ["S*/assets/**/*"]
        tasks: [
          "newer:copy:build_app_assets"
        ]

      express:
        files: ["bin/**/*.*", "!bin/server.js", "!bin/data.js"]
        tasks: []
        options:
          livereload: 8001

 
  grunt.renameTask "watch", "delta"

  grunt.registerTask "watch", [
    "build"
    "express"
    "delta"
  ]
  grunt.registerTask "default", [
    "build"
  ]
  grunt.registerTask "build", [
    "clean"
    "copy:build_app_assets"
    "jade"
    "livescript"
    "sass"
  ]
  