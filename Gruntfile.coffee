module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    coffee:
      options:
          bare: true      
      test:
        files: ['build/<%= pkg.name %>.<%= pkg.version %>.js': 'source/<%= pkg.name %>.<%= pkg.version %>.coffee', 'test/temp_test_spec.js': 'test/*.coffee']
      dev:
        files: 'build/<%= pkg.name %>.<%= pkg.version %>.js': 'source/<%= pkg.name %>.<%= pkg.version %>.coffee'      
          
    coffeelint:
      all: "source/*.coffee"

    clean:
      build: 'build/*',
      test: ['test/*.js', 'test/coverage_report/']

    uglify:
      options:
        banner: '/*! <%= pkg.name %> v<%= pkg.version %> <%= grunt.template.today(\'yyyy-mm-dd h:MM:ss TT Z\') %> */\n'
        mangle:
          except: 'StorageJS'
      dev:
        files:
          'build/<%= pkg.name %>.<%= pkg.version %>.min.js': 'build/<%= pkg.name %>.<%= pkg.version %>.js'
      prod:
        files:
          'public/js/<%= pkg.name %>.<%= pkg.version %>.min.js': 'build/<%= pkg.name %>.<%= pkg.version %>.js'

    jshint:
      build: 'build/<%= pkg.name %>.<%= pkg.version %>.js'
      test: 'test/*.js'

    compress:
      main:
        options:
          mode: 'gzip'
        files: [
          expand: true
          src: ['build/*.min.js']
          dest: ''
          ext: '.<%= pkg.version %>.min.gz.js'
        ]

    jasmine:
      src: 'build/<%= pkg.name %>.<%= pkg.version %>.js'
      options:
        specs: 'test/*.js'
        # template: require 'grunt-template-jasmine-istanbul'        
        # templateOptions:
        #   coverage: 'test/coverage/coverage.json'
        #   report: 'test/coverage_report/'

    s3:
      options:
        key: process.env.AWS_KEY
        secret: process.env.AWS_SECRET
        bucket: process.env.AWS_S3_BUCKET
        access: 'public-read'
      prod:
        upload:
          [
            src:  "build/<%= pkg.name %>.<%= pkg.version %>.min.gz.js"
            dest: "<%= pkg.name %>.<%= pkg.version %>.min.gz.js"
            headers:
              "Content-Encoding": "gzip"
              "Content-Type": "text/javascript"
          ]

    cloudfront:
      options:
        region: 'us-east-1'
        distributionId: process.env.AWS_CF_DIST_ID
        credentials:
          accessKeyId: process.env.AWS_KEY
          secretAccessKey: process.env.AWS_SECRET
      invalidate:
        Paths:
          Quantity: 1
          Items: ['/<%= pkg.name %>.<%= pkg.version %>.min.gz.js']
        CallerReference: Math.random().toString()

    watch:
      coffee:
        files: 'source/*.coffee',
        tasks: 'default'

    imagemin:
      dev:
        options:
          optimizationLevel: 3
        files: ['public/img.jpg': 'source/img.jpg']
      prod:
        options:
          optimizationLevel: 7
        files: ['public/img_prod.jpg': 'source/img.jpg']

    less:
      dev:
        files: ["public/app.css": "source/app.less"]

    cssmin:
      dev:
        files: ["public/app.min.css": "public/app.css"]

    htmlmin:
      options:
        removeComments: true,
        collapseWhitespace: true
      dev:
        files: ["public/index.min.html": "public/index.html"]

  # Load the task plugins:
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-nodeunit'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-compress'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-s3'
  grunt.loadNpmTasks 'grunt-cloudfront'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-imagemin'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-htmlmin'
  
  # Default task(s).
  grunt.registerTask 'default', ['coffeelint', 'coffee', 'jshint', 'uglify', 'compress']
  grunt.registerTask 'test', ['coffee:test', 'jshint:test', 'jasmine']
  grunt.registerTask 'deploy', ['default', 'test', 's3', 'cloudfront']
