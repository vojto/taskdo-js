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
    @append @listView
  
  update: (params) ->
    List.fetch()
    @list = list = List.find(params.list_id)
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
    task.save(remote: true, sync: true, action: "update", pathParams: {taskListID: @list.id, taskID: task.id})
  
  newTaskAction: (e) =>
    e.preventDefault()
    @navigate "/lists", @list.id, "tasks", "new"

module.exports = Tasks