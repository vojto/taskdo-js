require('lib/setup')

Spine = require('spine')
Kit = require('appkit')

Layout = require('controllers/layout')

class App extends Spine.Controller
  constructor: ->
    super
    @layout = new Layout(el: @el)
    @list = new Kit.List(items: [{name: "First"}, {name: "Second"}], type: 'grouped')
    @layout.setMain @list
    

module.exports = App