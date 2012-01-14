Spine = require('spine')
require('spine/lib/relation')
Showdown = require('lib/showdown')
# TODO: Use the new library instead of Showdown

module.exports = class Page extends Spine.Model
  @configure 'Page', 'title', 'content'
  
  @belongsTo "course", "models/course"
  
  @extend Spine.Model.Atmosphere
  
  formatContent: ->
    @_shodown ||= new Showdown.converter()
    @_shodown.makeHtml(@content)
  
window.Page = Page