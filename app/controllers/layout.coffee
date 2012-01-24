Spine = require('spine')
Kit     = require('appkit')

class Layout extends Kit.Controller
  template: require('views/layout')

  constructor: ->
    super
    @render()
  
  # Setting main content
  # ---------------------------------------------------------------------------
  
  setMain: (el) ->
    @$("#header .inside .buttons").html("")
    el = el.el if el.el?
    @$("#main").children().detach()
    @$("#main").append(el)
  
  # Setting title
  # ---------------------------------------------------------------------------

  setTitle: (title) ->
    @$("#header .inside .title").text(title)
    
  # Working with buttons
  # ---------------------------------------------------------------------------
  
  addTopButton: (title, action, type = null) ->
    button = $("<a />").attr("href", "#").text(title)
    button.addClass(type) if type
    button.addClass("button").addClass("background")
    button.click(action)
    @$("#header .inside .buttons").append(button)
    button
  
  setBackPath: (path) ->
    @$("a.back-button").show().unbind('click').bind 'click', =>
      @navigate path
  
  hideBackButton: ->
    @$("a.back-button").hide()
    
  
module.exports = Layout