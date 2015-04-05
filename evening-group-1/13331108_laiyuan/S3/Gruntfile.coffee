module.exports = (grunt)->
    grunt.initConfig
        watch:
            compile:
                files: [
                    'src/sass/**/*.sass'
                    'src/coffee/**/*.coffee'
                ]
                options:
                    spawn: false
                tasks: ['coffee', 'sass']
        sass:
            dist:
                files: [
                    expand: true
                    cwd: 'src/sass/'
                    src: '**/*.sass'
                    dest: 'bin/css'
                    ext: '.css'
                ]
        coffee:
            glob_to_multiple:
                expand: true,
                flatten: true,
                cwd: 'src/coffee',
                src: ['**/*.coffee']
                dest: 'bin/js',
                ext: '.js'

    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-sass'
    grunt.loadNpmTasks 'grunt-contrib-coffee'

    grunt.registerTask 'default', 'watch'

