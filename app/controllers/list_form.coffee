Kit = require('appkit')

List = require('models/list')

class ListForm extends Kit.Controller
  constructor: ->
    super
    fields = 
      title: "Title"
    @form = new Kit.Form(fields: fields, delegate: this)
    @append @form
    @active @update
  
  update: ->
    @layout.setMain(this)
    @layout.addTopButton "Back", @backAction, 'right'
  
  didSubmit: (object) ->
    list = new List(object)
    list.save(remote: true)
    @navigate '/lists'
    
  backAction: =>
    @navigate '/lists'
    
  
module.exports = ListForm