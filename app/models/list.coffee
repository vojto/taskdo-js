Spine   = require('spine')

class List extends Spine.Model
  @configure 'List', 'title', 'kind', 'selfLink'

module.exports = List