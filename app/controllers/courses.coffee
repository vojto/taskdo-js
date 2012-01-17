Spine = require('spine')
Kit     = require('appkit')

Course = require('models/course')

class Courses extends Kit.Controller
  # Lifecycle
  # ---------------------------------------------------------------------------  

  constructor: ->
    super
    @active @update
    @courses = new Kit.List(model: Course, delegate: this)
    @list = new Kit.GroupedList(groups: {"My Courses": @courses}, type: "small")
    @append @list
  
  update: ->
    @layout.setMain(this)
    @layout.addTopButton "New Course", @newAction, 'right'
    Course.fetch() # TODO: Sync, but not at all times
  
  listDidSelectItem: (list, item) ->
    alert "Selected item #{item.name}"
  
  # Actions
  # ---------------------------------------------------------------------------
  
  newAction: (e) =>
    e.preventDefault()
    @navigate '/courses/new'

module.exports = Courses