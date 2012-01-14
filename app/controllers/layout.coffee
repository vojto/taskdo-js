Spine = require('spine')
Kit = require('appkit')

class Layout extends Kit.Controller
  template: require('views/layout')
  
  constructor: ->
    super
    @render()
    @hideSidebar()
  
  # Setting main content
  # ---------------------------------------------------------------------------
  
  setMain: (el) ->
    el = el.el if el.el?
    @$("#main").html(el)
  
  # Showing/hiding sidebar
  # ---------------------------------------------------------------------------
  
  hideSidebar: ->
    @$('#sidebar').hide()
    @$('#content').addClass('without-sidebar')
  
  showSidebar: ->
    @$('#sidebar').show()
    @$('#content').removeClass('without-sidebar')
  
  
module.exports = Layout