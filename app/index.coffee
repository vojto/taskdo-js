require('lib/setup')

Spine   = require('spine')
Kit     = require('appkit')
Atmos   = require('atmos2')

Layout      = require('controllers/layout')
Lists       = require('controllers/lists')
# Courses     = require('controllers/courses')
# CourseForm  = require('controllers/course_form')
# Course      = require('models/course')

class App extends Spine.Controller
  constructor: ->
    super
    @_setupAtmos()

    @layout     = new Layout(el: @el)
    # @courses    = new Courses(layout: @layout)
    # @courseForm = new CourseForm(layout: @layout)
    @lists      = new Lists(layout: @layout)
    
    @routes
      '':             (params) -> @lists.active(params)
      '/lists':     (params) -> @lists.active(params)
      # '/courses/new': (params) -> @courseForm.active(params)
    
    Spine.Route.setup()
    # @navigate '/courses'
  
  _setupAtmos: ->
    # @atmos = new Atmos
    # @atmos.resourceClient.base = "http://"
    # @atmos.resourceClient.routes =
    #   Course:
    #     index: "/projects.json"
    #   Page:
    #     index: "/pages.json"
    # @atmos.resourceClient.IDField = "_id"

module.exports = App