Spine   = require('spine')
require('atmos2/lib/spine')

class List extends Spine.Model
  @configure 'List', 'title', 'kind', 'selfLink'
  
  @extend Spine.Model.Atmosphere

  remoteSaveOptions: (options) ->
    options.prepareData = (data) ->
      delete data.id if options.action == "create"
      data
    options

module.exports = List
window.List = List