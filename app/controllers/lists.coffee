Spine = require('spine')
Kit     = require('appkit')

List = require('models/list')

class Lists extends Kit.Controller
  # Lifecycle
  # ---------------------------------------------------------------------------  

  constructor: ->
    super
    @active @update
    
    # Create test list
    # list = new List(title: "Vojto's List")
    # list.save()
    
    # @courses = new Kit.List(model: Course, delegate: this)
    # @list = new Kit.GroupedList(groups: {"My Courses": @courses}, type: "small")
    @lists = new Kit.List(model: List, method: "title", delegate: this)
    @grouped = new Kit.GroupedList(groups: {"Your Lists": @lists})
    @append @grouped
  
  update: ->
    @layout.setMain(this)
    @layout.addTopButton "New List", @newAction, 'right'
    List.fetch() # Not sync
  
  listDidSelectItem: (list, item) ->
    alert "Selected item #{item.name}"
  
  # Actions
  # ---------------------------------------------------------------------------
  
  newAction: (e) =>
    e.preventDefault()
    @navigate '/lists/new'

module.exports = Lists