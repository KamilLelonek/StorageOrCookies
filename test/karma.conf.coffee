module.exports = (config) ->
  config.set
    frameworks : ['jasmine']
    preprocessors :
      '**/*.coffee' : ['coffee']
    coffeePreprocessor :
      options :
        bare : true
        sourceMap : false
      transformPath : (path) ->
        path.replace /\.coffee$/, '.js'
    files : [
      '../cookies_or_storage.js'
      '*.coffee'
    ]
    browsers : ['Chrome']
    plugins : [
      'karma-jasmine'
      'karma-coffee-preprocessor'
      'karma-chrome-launcher'
      'karma-coverage'
      'karma-junit-reporter'
      'karma-growl'
    ]
    reporters : ['progress', 'junit', 'growl', 'coverage']
    singleRun : true
