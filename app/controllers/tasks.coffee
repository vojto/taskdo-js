Spine = require('spine')
Kit     = require('appkit')

List = require('models/list')
Task = require('models/task')

class Tasks extends Kit.Controller
  constructor: ->
    super
    @active @update
    
    @listView = new Kit.List(model: Task, method: "title", delegate: this, type: 'tasks')
    @listView.predicate = (task) => task.task_list_id == @list.id
    @listView.sort = (a, b) -> a.position - b.position
    @listView.itemClass = (task) -> task.status
    @append @listView
  
  update: (params) ->
    List.fetch()
    @list = list = List.find(params.list_id)
    update = (task) -> task.task_list_id = list.id
    Task.sync(remote: true, pathParams: {taskListID: @list.id}, updateData: update)
    
    @layout.setMain(this)
    @layout.setTitle(@list.title)

module.exports = Tasks