require('lib/setup')

Spine   = require('spine')
Kit     = require('appkit')
Atmos   = require('atmos2')
Defaults = require('atmos2/lib/defaults')

Layout      = require('controllers/layout')
Lists       = require('controllers/lists')
ListForm    = require('controllers/list_form')
Tasks       = require('controllers/tasks')
TaskForm    = require('controllers/task_form')
List        = require('models/list')

class App extends Spine.Controller
  constructor: ->
    super
    @_setupAtmos()

    @layout     = new Layout(el: @el)
    @lists      = new Lists(layout: @layout)
    @listForm   = new ListForm(layout: @layout)
    @tasks      = new Tasks(layout: @layout)
    @taskForm   = new TaskForm(layout: @layout)
    
    @route /access_token=(.*?)&token_type=(.*?)&expires_in=(.*?)/, @authorize
    @routes
      '':                       (params) -> @lists.active(params)
      '/':                      (params) -> @lists.active(params)
      '/lists':                 (params) -> @lists.active(params)
      '/lists/new':             (params) -> @listForm.active(params)
      '/lists/:list_id/tasks':  (params) -> @tasks.active(params)
      '/lists/:list_id/tasks/new': (params) -> @taskForm.active(params)
      '/tasks/:task_id/edit':   (params) -> @taskForm.active(params)
      '/login':                 (params) -> @login()
    
    Spine.Route.setup()
    
  
  _setupAtmos: ->
    @atmos = new Atmos
    @atmos.resourceClient.base = "https://www.googleapis.com/tasks/v1"
    @atmos.resourceClient.routes =
      List:
        index: "GET /users/@me/lists"
        create: "POST /users/@me/lists"
        clear: "POST /lists/:taskListID/clear"
      Task:
        index: "GET /lists/:taskListID/tasks"
        create: "POST /lists/:taskListID/tasks"
        update: "PUT /lists/:taskListID/tasks/:taskID"
        move: "POST /lists/:taskListID/tasks/:taskID/move"
    @atmos.resourceClient.itemsFromResult = (result) -> result.items
    @atmos.resourceClient.dataCoding = "json"
    @atmos.resourceClient.beforeRequest = @_checkToken
    @atmos.bind 'auth_fail', =>
      @navigate '/login'
    @_setupAtmosAuth()
    @atmos.setNeedsSync()
    
  _setupAtmosAuth: ->
    token = Defaults.get 'auth_token'
    console.log "Setting token to #{token}"
    @atmos.resourceClient.addHeader "Authorization", "OAuth #{token}"
  
  _checkToken: (callback) =>
    expires = parseFloat(Defaults.get('expires_on'))
    current = parseFloat(new Date().getTime() / 1000)
    console.log expires
    return callback() if !expires? || isNaN(expires)
    delta = expires - current
    return callback() if delta > 60
    if macgap?
      console.log "gonna refresh the token, delta = #{expires-current}"
      self = this
      macgap.auth.refresh (token, expiresOn) =>
        console.log "check token callback called #{token} #{expiresOn}"
        Defaults.set('auth_token', token)
        Defaults.set 'expires_on', expiresOn
        @_setupAtmosAuth()
        callback()
    else
      console.log "won't refresh token because macgap is not available"
      callback()
  
  login: ->
    redirectURI = encodeURIComponent("http://localhost:9294/")
    path = "https://accounts.google.com/o/oauth2/auth"
    clientID = "1022359456025.apps.googleusercontent.com"
    scope = "https://www.googleapis.com/auth/tasks"
    url = "#{path}?response_type=token&client_id=#{clientID}&redirect_uri=#{redirectURI}&scope=#{scope}"
    if macgap?
      self = this
      macgap.auth.login (token, expiresOn) =>
        console.log "Login successful"
        Defaults.set 'auth_token', token
        Defaults.set 'expires_on', expiresOn
        @_setupAtmosAuth()
        @navigate "/"
    else
      window.location = url
  
  authorize: (params) =>
    console.log 'authorizing', params
    {match} = params
    token = match[1]
    type = match[2]
    expires = match[3]
    console.log "token: #{token}"
    Defaults.set 'auth_token', token
    @_setupAtmosAuth()
    @navigate '/'


module.exports = App