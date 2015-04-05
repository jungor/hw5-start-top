module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)
  path = require('path')
  pkg = grunt.file.readJSON("package.json")
  DEBUG = false # 添加测试所需代码，发布时应该为false

  grunt.initConfig
    pkg: pkg
    meta:
      banner: '/**\n" + " * <%= pkg.name %> - v<%= pkg.version %> - <%= grunt.template.today(\"yyyy-mm-dd\") %>\n" + " * <%= pkg.homepage %>\n" + " *\n" + " * Copyright (c) <%= grunt.template.today(\"yyyy\") %> <%= pkg.author %>\n" + " * Licensed <%= pkg.licenses.type %> <<%= pkg.licenses.url %>>\n" + " */\n'

    clean:
      all:
        dot: true
        files:
          src: ["s*/*", "!src/*"]

    copy:
      s1:
        files: [
          src: ["**/*.*", "!**/*.{jade,ls,sass}"]
          dest: "s1/"
          cwd: "src/"
          expand: true
        ]
      s2:
        files: [
          src: ["**/*.*", "!**/*.{jade,ls,sass}"]
          dest: "s2/"
          cwd: "src/"
          expand: true
        ]
      s3:
        files: [
          src: ["**/*.*", "!**/*.{jade,ls,sass}"]
          dest: "s3/"
          cwd: "src/"
          expand: true
        ]
      s4:
        files: [
          src: ["**/*.*", "!**/*.{jade,ls,sass}"]
          dest: "s4/"
          cwd: "src/"
          expand: true
        ]
      s5:
        files: [
          src: ["**/*.*", "!**/*.{jade,ls,sass}"]
          dest: "s5/"
          cwd: "src/"
          expand: true
        ]

    livescript:
        options:
            bare: false
        s1:
            expand: true
            cwd: "src/"
            src: ["**/*.ls"]
            dest: "s1/"
            ext: ".js"
        s2:
            expand: true
            cwd: "src/"
            src: ["**/*.ls"]
            dest: "s2/"
            ext: ".js"

        s3:
            expand: true
            cwd: "src/"
            src: ["**/*.ls"]
            dest: "s3/"
            ext: ".js"

        s4:
            expand: true
            cwd: "src/"
            src: ["**/*.ls"]
            dest: "s4/"
            ext: ".js"

        s5:
            expand: true
            cwd: "src/"
            src: ["**/*.ls"]
            dest: "s5/"
            ext: ".js"

    express:
      dev:
        options:
          port: 8000
          server: path.resolve('server.js')
          bases: [path.resolve('/')]
          livereload: 8001
          # serverreload: true

    delta:
        options:
            livereload: true
        livescript:
            files: ["src/*.ls"]
            tasks: ["livescript"]
        express:
            files: ["s*/**/*.*", "!server.js"]
            tasks: ["express"]
            options:
              livereload: 8001
        config:
          files: ["Gruntfile.js", "Gruntfile.coffee"]
          options:
            reload: true

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
    "copy"
    "livescript"
  ]


