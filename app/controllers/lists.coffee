Spine = require('spine')
Kit     = require('appkit')

List = require('models/list')
Task = require('models/task')

class Lists extends Kit.Controller
  # Lifecycle
  # ---------------------------------------------------------------------------  

  constructor: ->
    super
    @active @update
    
    @shouldSync = true
    @lists = new Kit.List(model: List, method: "title", delegate: this)
    @append @lists
  
  update: ->
    @layout.setTitle("Your Lists")
    @layout.setMain(this)
    @layout.addTopButton "New List", @newAction
    @layout.hideBackButton()
    List.sync(remote: true, remove: true) if @shouldSync
    @shouldSync = false
  
  didSelect: (list) ->
    @navigate '/lists', list.id, 'tasks'
  
  # Actions
  # ---------------------------------------------------------------------------
  
  newAction: (e) =>
    e.preventDefault()
    @navigate '/lists/new'

module.exports = Lists