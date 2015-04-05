module.exports = (grunt) ->

  grunt.initConfig

    pkg: grunt.file.readJSON('package.json')
    debug: true

    meta:
      basePath: '.'
      srcPath: 'src/'
      destPath:
        css: 'bin/assets/css/'
        js: 'bin/'
        html: 'bin/'

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

    copy:
      main:
        src: '**'
        cwd: '<%= meta.destPath.html %>'
        dest: '<%= meta.basePath %>'
        expand: true

    clean: [
      '<%= basePath %>assets'
      '<%= basePath %>index.*'
      '<%= basePath %>.sass-cache'
      '<%= meta.destPath.html %>*.html'
      '<%= meta.destPath.css %>*.css'
      '<%= meta.destPath.js %>*.js'
    ]

    watch:
      sass:
        files: '<%= meta.srcPath %>index.sass'
        tasks: ['sass', 'copy']
      livescript:
        files: '<%= meta.srcPath %>index.ls'
        tasks: ['livescript', 'copy']
      jade:
        files: '<%= meta.srcPath %>index.jade'
        tasks: ['jade', 'copy']


  grunt.loadNpmTasks('grunt-livescript')
  grunt.loadNpmTasks('grunt-contrib-jade')
  grunt.loadNpmTasks('grunt-contrib-sass')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-clean')

  grunt.registerTask('default', ['sass', 'livescript', 'jade', 'copy'])
