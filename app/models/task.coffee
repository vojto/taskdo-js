Spine   = require('spine')
require('atmos2/lib/spine')

class Task extends Spine.Model
  @configure 'Task', 'title', 'notes', 'position', 'updated', 'due', 'hidden', 'status', 'deleted', 'task_list_id'
  
  @extend Spine.Model.Atmosphere
  
  toggleStatus: ->
    if @status == "needsAction"
      @status = "completed"
    else
      @status = "needsAction"
    @

module.exports = Task
window.Task = Task