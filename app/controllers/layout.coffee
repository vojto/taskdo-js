Spine = require('spine')
Kit     = require('appkit')

class Layout extends Kit.Controller
  template: require('views/layout')
  
  constructor: ->
    super
    @render()
    @hideSidebar()
  
  # Setting main content
  # ---------------------------------------------------------------------------
  
  setMain: (el) ->
    @$("#top").html("")
    el = el.el if el.el?
    @$("#main").children().detach()
    @$("#main").append(el)
  
  # Showing/hiding sidebar
  # ---------------------------------------------------------------------------
  
  hideSidebar: ->
    @$('#sidebar').hide()
    @$('#content').addClass('without-sidebar')
  
  showSidebar: ->
    @$('#sidebar').show()
    @$('#content').removeClass('without-sidebar')
    
  # Working with buttons
  # ---------------------------------------------------------------------------
  
  addTopButton: (title, action, type = null) ->
    button = $("<a />").attr("href", "#").text(title)
    button.addClass(type) if type
    button.addClass("button").addClass("background")
    button.click(action)
    @$("#top").append(button)
    button
  
module.exports = Layout