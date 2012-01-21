require('lib/setup')

Spine   = require('spine')
Kit     = require('appkit')
Atmos   = require('atmos2')
Defaults = require('atmos2/lib/defaults')

Layout      = require('controllers/layout')
Lists       = require('controllers/lists')
# Courses     = require('controllers/courses')
# CourseForm  = require('controllers/course_form')
List        = require('models/list')

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
      '/lists':       (params) -> @lists.active(params)
      '/login':       (params) -> @login()
    @route /access_token=(.*?)&token_type=(.*?)&expires_in=(.*?)/, @authorize
    
    Spine.Route.setup()
    # @navigate '/courses'
    
  
  _setupAtmos: ->
    @atmos = new Atmos
    @atmos.resourceClient.base = "https://www.googleapis.com/tasks/v1/users/@me/"
    @atmos.resourceClient.routes =
      List:
        index: "lists"
    Defaults.get 'auth_token', (token) =>
      @atmos.resourceClient.addHeader "Authorization", "OAuth #{token}"
    @atmos.resourceClient.itemsFromResult = (result) ->
      result.items
    List.sync(remote: true)
  
  login: ->
    redirectURI = encodeURIComponent("http://localhost:9294/")
    path = "https://accounts.google.com/o/oauth2/auth"
    clientID = "1022359456025.apps.googleusercontent.com"
    scope = "https://www.googleapis.com/auth/tasks"
    window.location = "#{path}?response_type=token&client_id=#{clientID}&redirect_uri=#{redirectURI}&scope=#{scope}"
  
  authorize: (params) =>
    {match} = params
    token = match[1]
    type = match[2]
    expires = match[3]
    console.log "token: #{token}"
    Defaults.set 'auth_token', token


module.exports = App