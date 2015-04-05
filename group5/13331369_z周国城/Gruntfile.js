module.exports = function(grunt) {
    grunt.initConfig({
       pkg: grunt.file.readJSON('package.json'),
       log: {
          foo: [1, 2, 3],
          bar: 'hello world',
          baz: false
},

       sass: {
       	 tests: {
       	 	expand: true,
       	 	cwd: 'src/',
       	 	src: ['*.sass'],
       	 	dest: 's1',
       	 	ext: '.css'
       	 }
       },
       
       livescript: {
       	 des: {
       	 	expand: true,
       	 	cwd: 'src/',
       	 	src: ['*.ls'],
       	 	dest: 's1',
       	 	ext: '.js'
       	 }
       },

       jade: {
       	 tests: {
       	 	expand: true,
       	 	cwd: 'src/',
       	 	src: ['*.jade'],
       	 	dest: 's1',
       	 	ext: '.html'
       	 }
       },

       watch: {
        files: ['src/*.ls', 'src/*.sass', 'src/*.jade'],
        tasks: ['sass', 'jade', 'livescript']
       }
});
     grunt.loadNpmTasks('grunt-livescript');
     grunt.loadNpmTasks('grunt-sass');
     grunt.loadNpmTasks('grunt-contrib-jade');
     grunt.loadNpmTasks('grunt-contrib-watch');


     grunt.registerTask('default', ['jade', 'sass', 'livescript']);
};

