module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)
  path = require('path')
  pkg = grunt.file.readJSON('package.json')

  grunt.initConfig
    pkg: pkg
    clean:
      all:
        dot: true
        files:
          src: ["bin/*"]

    copy:
      assets:
        files: [
          src:    ["**/*.*", "!**/*.ls"]
          cwd:    "src/"
          dest:   "bin/"
          expand: true
        ]

    livescript:
      options:
        bare: false
      index:
        expand: true
        cwd: "src/"
        src: ["S*/index.ls", "server.ls"]
        dest: "bin/"
        ext: ".js"

    express:
      custom:
        options:
          server: path.resolve('bin/server')
          bases: [path.resolve('bin')]
          livereload: true

    watch:
      options:
        liverelode:
          true
      all:
        files:    ['src/*']
        tasks:    ['newer:copy', 'newer:livescript']
      #express:
      #  files: ["bin/**/*.*", "!bin/server.js"]
      #  tasks: ['express']
      #  options:
      #    livereload: 3001

  grunt.registerTask "default", [
    "clean"
    "copy"
    "livescript"
    #"express"
    "watch"
  ]

  grunt.registerTask "watch", [
    "watch"
  ]
