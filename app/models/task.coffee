Spine   = require('spine')
require('atmos2/lib/spine')

class Task extends Spine.Model
  @configure 'Task', 'title', 'notes', 'position', 'updated', 'due', 'hidden', 'status', 'deleted', 'task_list_id'
  
  @extend Spine.Model.Atmosphere

module.exports = Task
window.Task = Task