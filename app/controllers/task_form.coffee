Kit = require('appkit')

Task = require('models/task')

class TaskForm extends Kit.Controller
  constructor: ->
    super
    fields = 
      title: "Title"
      notes: "Notes"
    types =
      notes: "textarea"
    @form = new Kit.Form(fields: fields, delegate: this, types: types)
    @el = @form.el
    @active @update
  
  update: (params) ->
    List.fetch()
    @list = List.find(params.list_id)
    @layout.setMain(this)
    @layout.setTitle "Edit Task"
    @layout.addTopButton "Save", @submitAction
  
  didSubmit: (object) ->
    console.log "submitted", object
    # list = new List(object)
    # list.save(remote: true)
    # @navigate '/lists'
  
  submitAction: (e) =>
    e.preventDefault()
    @form.submit()
    
  backAction: =>
    @navigate '/lists'
    
  
module.exports = TaskForm