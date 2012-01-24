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
    @layout.setBackPath "/lists/#{@list.id}/tasks"
  
  didSubmit: (object) ->
    task = new Task(object)
    task.status = "needsAction"
    task.task_list_id = @list.id
    task.save(remote: true, sync: true, action: "create", pathParams: {taskListID: @list.id})
    @navigate '/lists', @list.id, 'tasks'
  
  submitAction: (e) =>
    e.preventDefault()
    @form.submit()
    
  backAction: =>
    @navigate '/lists'
    
  
module.exports = TaskForm