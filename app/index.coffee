require('lib/setup')

Spine   = require('spine')
Kit     = require('appkit')
Atmos   = require('atmos2')

Layout  = require('controllers/layout')
Course  = require('models/course')

class App extends Spine.Controller
  constructor: ->
    super
    @layout = new Layout(el: @el)
    @list = new Kit.List(model: Course, type: 'grouped')
    @layout.setMain @list
    
    
    @atmos = new Atmos
    @atmos.resourceClient.base = "http://localhost:3000/api"
    @atmos.resourceClient.routes =
      Course:
        index: "/projects.json"
      Page:
        index: "/pages.json"
    @atmos.resourceClient.IDField = "_id"
    Course.sync()
    

module.exports = App