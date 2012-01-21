Spine   = require('spine')
require('atmos2/lib/spine')

class List extends Spine.Model
  @configure 'List', 'title', 'kind', 'selfLink'
  
  @extend Spine.Model.Atmosphere

module.exports = List