Spine = require('spine')
Kit     = require('appkit')
Atmos   = require('atmos2')

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
    @listView.inside.sortable({axis: 'y', update: @_didSort})
  
  _didSort: (event, ui) =>
    index = @listView.indexForTarget(ui.item)
    task = @listView.itemAtIndex(index)
    previous = if index == 0 then null else @listView.itemAtIndex(index-1)
    options = {collection: "Task", action: "move", params: {}}
    options.pathParams = {taskListID: @list.id, taskID: task.id}
    options.params.previous = previous.id if previous
    console.log 'executing with', options
    Atmos.instance.resourceClient.execute options, (result) ->
      task.position = result.position
      task.save()
  
  update: (params) ->
    List.fetch()
    list = List.find(params.list_id)
    @shouldSync = true if list != @list
    @list = list
    update = (task) -> task.task_list_id = list.id
    removeScope = (task) -> task.task_list_id == list.id
    Task.sync(remote: true, pathParams: {taskListID: @list.id}, updateData: update, remove: true, removeScope: removeScope) if @shouldSync
    @shouldSync = false
    
    @layout.setMain(this)
    @layout.setTitle(@list.title)
    @layout.addTopButton "Clean Up", @cleanAction
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
  
  cleanAction: (e) =>
    e.preventDefault()
    options = {collection: "List", action: "clear", pathParams: {taskListID: @list.id}}
    for task in @listView.items
      task.destroy() if task.status == "completed"
    Atmos.instance.resourceClient.execute options, (result) =>

module.exports = Tasks