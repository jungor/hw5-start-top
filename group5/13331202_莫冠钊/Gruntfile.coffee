module.exports = (grunt) ->
    coffeeify = require("coffeeify")
    path = require("path")
    grunt.initConfig
        coffee:
            glob_to_multiple:
                files:
                    './S1/s1.js': './S1/s1.coffee'
                    './S2/s2.js': './S2/s2.coffee'
                    './S3/s3.js': './S3/s3.coffee'
                    './S4/s4.js': './S4/s4.coffee'
                    './S5/s5.js': './S5/s5.coffee'


        # Minify files with UglifyJS
        uglify:
            build:
                files: [{
                    expand: true
                    cwd: 'bin/js'
                    src: '**/*.js'
                    dest: 'dist/js'
                }]

        # Run predefined tasks whenever watched file patterns are added, changed or deleted 
        watch:
            compile:
                files: [
                    "src/**/*.coffee"
                ]
                tasks: ["coffee"]


        nodemon:
            dev: 
                script: "server.js"
                options:
                    ext: "js,coffee"
                    debug: true

    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-contrib-uglify"
    grunt.loadNpmTasks "grunt-contrib-copy"
    grunt.loadNpmTasks "grunt-contrib-coffee"
    grunt.loadNpmTasks 'grunt-nodemon'

    grunt.registerTask "watch", ->
        grunt.task.run [
            "coffee"
            "nodemon"
            "watch"
        ]
    grunt.registerTask "build", ->
        grunt.task.run [
            "browserify"
            "uglify"
            "copy"
        ]