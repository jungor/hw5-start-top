module.exports = (grunt) ->

  grunt.initConfig

    pkg: grunt.file.readJSON('package.json')
    debug: true

    meta:
      basePath: './'
      srcPath: 'src/'
      destPath:
        css: 'assets/css/'
        js: './'
        html: './'

    sass:
      options:
        style: 'expanded'
        sourcemap: 'none'
      dist:
        files: [
          expand: true
          cwd: '<%= meta.srcPath %>'
          src: 'index.sass'
          dest: '<%= meta.destPath.css %>'
          ext: '.css'
        ]

    livescript:
      dist:
        files: [
          expand: true
          cwd: '<%= meta.srcPath %>'
          src: 'index.ls'
          dest: '<%= meta.destPath.js %>'
          ext: '.js'
        ]

    jade:
      options:
        pretty: true
      dist:
        files: [
          expand: true
          cwd: '<%= meta.srcPath %>'
          src: 'index.jade'
          dest: '<%= meta.destPath.html %>'
          ext: '.html'
        ]

    clean: [
      '<%= meta.basePath %>.sass-cache'
      '<%= meta.destPath.html %>index.html'
      '<%= meta.destPath.css %>index.css'
      '<%= meta.destPath.js %>index.js'
    ]

    watch:
      sass:
        files: '<%= meta.srcPath %>index.sass'
        tasks: 'sass'
      livescript:
        files: '<%= meta.srcPath %>index.ls'
        tasks: 'livescript'
      jade:
        files: '<%= meta.srcPath %>index.jade'
        tasks: 'jade'


  grunt.loadNpmTasks('grunt-livescript')
  grunt.loadNpmTasks('grunt-contrib-jade')
  grunt.loadNpmTasks('grunt-contrib-sass')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-clean')

  grunt.registerTask('default', ['sass', 'livescript', 'jade'])
