Kit = require('appkit')

class CourseForm extends Kit.Controller
  constructor: ->
    super
    @form = new Kit.Form(fields: {test: "LOL"}, delegate: this)
    @append @form
    @active @update
  
  update: ->
    @layout.setMain(this)
    @layout.addTopButton "Back", @backAction, 'right'
  
  didSubmit: ->
    @navigate '/courses'
    
  backAction: =>
    @navigate '/courses'
    
  
module.exports = CourseForm