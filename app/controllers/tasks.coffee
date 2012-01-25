Spine = require('spine')
Kit     = require('appkit')

List = require('models/list')
Task = require('models/task')

class Tasks extends Kit.Controller
  constructor: ->
    super
    @active @update
    @shouldSync = true
    
    @listView = new Kit.List(model: Task, method: "title", delegate: this, type: 'tasks')
    @listView.predicate = (task) => task.task_list_id == @list.id
    @listView.sort = (a, b) -> a.position - b.position
    @listView.itemClass = (task) -> task.status
    @listView.accessory = true
    @append @listView
  
  update: (params) ->
    List.fetch()
    list = List.find(params.list_id)
    @shouldSync = true if list != @list
    @list = list
    update = (task) -> task.task_list_id = list.id
    Task.sync(remote: true, pathParams: {taskListID: @list.id}, updateData: update) if @shouldSync
    @shouldSync = false
    
    @layout.setMain(this)
    @layout.setTitle(@list.title)
    @layout.addTopButton "New Task", @newTaskAction
    @layout.setBackPath "/lists"
  
  didSelect: (task) ->
    task.toggleStatus()
    console.log {taskListID: @list.id, taskID: task.id}
    task.save(remote: true)
  
  newTaskAction: (e) =>
    e.preventDefault()
    @navigate "/lists", @list.id, "tasks", "new"
  
  didSelectAccessory: (task) =>
    @navigate '/tasks', task.id, 'edit', {list_id: task.task_list_id}

module.exports = Tasks