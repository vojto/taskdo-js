require('lib/setup')

Spine   = require('spine')
Kit     = require('appkit')
Atmos   = require('atmos2')
Defaults = require('atmos2/lib/defaults')

Layout      = require('controllers/layout')
Lists       = require('controllers/lists')
ListForm    = require('controllers/list_form')
Tasks       = require('controllers/tasks')
List        = require('models/list')

class App extends Spine.Controller
  constructor: ->
    super
    @_setupAtmos()

    @layout     = new Layout(el: @el)
    @lists      = new Lists(layout: @layout)
    @listForm   = new ListForm(layout: @layout)
    @tasks      = new Tasks(layout: @layout)
    
    @route /access_token=(.*?)&token_type=(.*?)&expires_in=(.*?)/, @authorize
    @routes
      '':                       (params) -> @lists.active(params)
      '/':                      (params) -> @lists.active(params)
      '/lists':                 (params) -> @lists.active(params)
      '/lists/new':             (params) -> @listForm.active(params)
      '/lists/:list_id/tasks':  (params) -> @tasks.active(params)
      '/login':                 (params) -> @login()
    
    Spine.Route.setup()
    
  
  _setupAtmos: ->
    @atmos = new Atmos
    @atmos.resourceClient.base = "https://www.googleapis.com/tasks/v1"
    @atmos.resourceClient.routes =
      List:
        index: "GET /users/@me/lists"
        create: "POST /users/@me/lists"
      Task:
        index: "GET /lists/:taskListID/tasks"
    @atmos.resourceClient.itemsFromResult = (result) -> result.items
    @atmos.resourceClient.dataCoding = "json"
    @atmos.bind 'auth_fail', =>
      result = confirm("Auth failed, login again?")
      @navigate '/login' if result
    @_setupAtmosAuth()
    @atmos.setNeedsSync()
  
  _setupAtmosAuth: ->
    Defaults.get 'auth_token', (token) =>
      @atmos.resourceClient.addHeader "Authorization", "OAuth #{token}"
  
  login: ->
    redirectURI = encodeURIComponent("http://localhost:9294/")
    path = "https://accounts.google.com/o/oauth2/auth"
    clientID = "1022359456025.apps.googleusercontent.com"
    scope = "https://www.googleapis.com/auth/tasks"
    window.location = "#{path}?response_type=token&client_id=#{clientID}&redirect_uri=#{redirectURI}&scope=#{scope}"
  
  authorize: (params) =>
    console.log 'authorizing'
    {match} = params
    token = match[1]
    type = match[2]
    expires = match[3]
    console.log "token: #{token}"
    Defaults.set 'auth_token', token
    @_setupAtmosAuth()
    @navigate '/'


module.exports = App