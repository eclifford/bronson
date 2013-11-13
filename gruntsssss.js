module.exports = function( grunt ) {

  // Towelie Tasks
  grunt.registerTask('run', 'clean:temp coffee connect:staging watch');
  grunt.registerTask('test', 'clean:temp coffee testem');
  grunt.registerTask('build', 'clean:temp coffee concat min');

  //
  // Grunt configuration:
  //
  // https://github.com/cowboy/grunt/blob/master/docs/getting_started.md
  //
  grunt.initConfig({
    meta: {
      version: '1.0.2',
      banner: '//   BronsonJS - v<%= meta.version %> - ' +
        '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
        '//   http://github.com/eclifford/bronson/\n' +
        '//   Copyright (c) <%= grunt.template.today("yyyy") %> ' +
        'Eric Clifford; Licensed MIT'
    },
    concat: {
      dist: {
        src: ['<banner:meta.banner>', '.temp/lib/bronson.js'],
        dest: 'build/bronson-<%= meta.version %>.js'
      }  
    },
    min: {
      dist: {
        src: ['<banner:meta.banner>', '.temp/lib/bronson.js'],
        dest: 'build/bronson-<%= meta.version %>.min.js'
      }
    },
    //
    // towelie configuration
    // setup towelie configuration to be used by grunt tasks below
    //
    towelie: {
      paths: {
        staging: ".temp",
        production: "dist",
        dev: "lib",
        test: "test"
      },
      server: {
        hostname: "localhost",
        port: "3501"
      }
    },
    //
    // grunt-contrib-connect
    // http://github.com/gruntjs/grunt-contrib-connect
    //
    connect: {
      staging: {
        port: '<config:towelie.server.port>',
        hostname: '<config:towelie.server.hostname>',
        dev: '<config:towelie.paths.dev>',
        staging: '<config:towelie.paths.staging>',
        middleware: function(connect, options) {
          return [
            connect.static(options.dev),
            connect.static(options.staging),
            connect.directory(options.dev)
          ];
        }
      }
    },
    //
    // grunt-watch
    //
    watch: {
      coffee: {
        files: '<%= towelie.paths.dev %>/**/*.coffee',
        tasks: 'coffee:app'
      },
      tests: {
        files: [
          '<%= towelie.paths.test %>/specs/**/*.coffee'
        ],
        tasks: 'coffee:tests'
      }
    },
    //
    // grunt-contrib-coffee
    // https://github.com/gruntjs/grunt-contrib-coffee/
    //
    coffee: {
      app: {
        files: {
          '.temp/lib/*.js': '<%= towelie.paths.dev %>/**/*.coffee'
        },
        options: {
          basePath: '<%= towelie.paths.dev %>'
        }
      },
      tests: {
        files: {
          '<%= towelie.paths.staging %>/specs/*.js': '<%= towelie.paths.test %>/specs/**/*.coffee'
        },
        options: {
          basePath: '<%= towelie.paths.test %>/specs'
        }
      }
    },
    //
    // grunt-testem
    // https://github.com/sideroad/grunt-testem
    //
    testem: {
      options: {
        files: [
          "test/index.html"
        ],
        routes: {
          "/lib":   ".temp/lib",
          "/specs": ".temp/specs"
        },
        launch_in_ci: [
          "phantomjs"
        ],
        launch_in_dev: [
          "phantomjs"
        ],
        src_files: [
          ".temp/**/*.js"
        ],
        serve_files: [
          ".temp/specs/**/*.js"
        ]
      }
    },
    //
    // grunt-contrib-clean
    // https://github.com/gruntjs/grunt-contrib-clean
    //
    clean: {
      temp: ['<%= towelie.paths.staging %>/'],
      dist: ['<%= towelie.paths.production %>/']
    }
  });
};
