module.exports = function(grunt) {
	require('load-grunt-tasks')(grunt)

	grunt.initConfig({

    	pkg: grunt.file.readJSON("package.json"),

    	meta: {
    		banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
    	},

		livescript: {
		    src: {
		     	files: {
			        'S1/js/index.js': 'S1/js/index.ls',
			        'S2/js/index.js': 'S2/js/index.ls',
			        'S3/js/index.js': 'S3/js/index.ls',
			        'S4/js/index.js': 'S4/js/index.ls',
			        'S5/js/index.js': 'S5/js/index.ls'
		    	}
		    }
		}
	});

	grunt.loadNpmTasks('grunt-livescript');
	grunt.loadNpmTasks('grunt-contrib-watch');

	grunt.registerTask("watch", ["build"]);
	grunt.registerTask("build", ["livescript"]);

};