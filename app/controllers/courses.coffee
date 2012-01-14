Spine = require('spine')
Kit     = require('lib/appkit/index')

Course = require('models/course')

class Courses extends Kit.Controller
  constructor: ->
    super
    @active @_didActivate
    @courses = new Kit.List(model: Course, delegate: this)
    @list = new Kit.GroupedList(groups: {"My Courses": @courses})
    @append @list
  
  _didActivate: ->
    Course.sync()
  
  listDidSelectItem: (list, item) ->
    alert "Selected item #{item.name}"

module.exports = Courses