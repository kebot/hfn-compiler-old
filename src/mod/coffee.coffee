# auto compile coffee-script

coffee = require('coffee-script')
_ = require('underscore')

ROOT = './example'

#

{js, sourceMap, v3SouceMap} = coffee.compile(
  'something coffee-script',
  _.extend({
    bare: true,
    sourceMap: true,
    sourceFiles: [path.basename(filePath)]
  }, customOptions))



