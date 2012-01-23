Kit = require('appkit')

List = require('models/list')

class ListForm extends Kit.Controller
  constructor: ->
    super
    fields = 
      title: "Title"
    @form = new Kit.Form(fields: fields, delegate: this)
    @el = @form.el
    @active @update
  
  update: ->
    @layout.setMain(this)
    @layout.setTitle "Edit List"
    @layout.addTopButton "Save", @submitAction
  
  didSubmit: (object) ->
    console.log "submitted", object
    list = new List(object)
    list.save(remote: true)
    @navigate '/lists'
  
  submitAction: (e) =>
    e.preventDefault()
    console.log "submitting like a baus"
    @form.submit()
    
  backAction: =>
    @navigate '/lists'
    
  
module.exports = ListForm