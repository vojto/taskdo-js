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
    Task.fetch()
    @list = List.find(params.list_id)
    @task = null
    @task = Task.find(params.task_id) if params.task_id
    @form.setValues(@task.attributes()) if @task
    @layout.setMain(this)
    @layout.setTitle "Edit Task"
    @layout.addTopButton "Save", @submitAction
    @layout.setBackPath "/lists/#{@list.id}/tasks"
  
  didSubmit: (object) ->
    if !@task
      @task = new Task(object)
      @task.status = "needsAction"
      @task.position = "0"
      @task.task_list_id = @list.id
    else
      @task.load(object)
    @task.save(remote: true)
    @navigate '/lists', @list.id, 'tasks'
  
  submitAction: (e) =>
    e.preventDefault()
    @form.submit()
    
  backAction: =>
    @navigate '/lists'
    
  
module.exports = TaskForm