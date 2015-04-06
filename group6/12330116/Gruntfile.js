module.exports = function(grunt) {
	grunt.initConfig({
		coffee : {
			compile : {
				options : {
					bare : true
				},
				files : {
					'S1/index.js' : 'S1/index.coffee',
					'S2/index.js' : 'S2/index.coffee',
					'S3/index.js' : 'S3/index.coffee',
					'S4/index.js' : 'S4/index.coffee',
					'S5/index.js' : 'S5/index.coffee'
				}
			}
		}
	});
	grunt.loadNpmTasks('grunt-contrib-coffee');
	grunt.registerTask('default',['coffee']);
};