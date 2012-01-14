require('lib/setup')

Spine   = require('spine')
Kit     = require('lib/appkit/index')
Atmos   = require('atmos2')

Layout  = require('controllers/layout')
Courses = require('controllers/courses')
Course  = require('models/course')

class App extends Spine.Controller
  constructor: ->
    super
    @_setupAtmos()

    @layout = new Layout(el: @el)

    @courses = new Courses
    @layout.setMain @courses.active()
  
  _setupAtmos: ->
    @atmos = new Atmos
    @atmos.resourceClient.base = "http://localhost:3000/api"
    @atmos.resourceClient.routes =
      Course:
        index: "/projects.json"
      Page:
        index: "/pages.json"
    @atmos.resourceClient.IDField = "_id"

module.exports = App