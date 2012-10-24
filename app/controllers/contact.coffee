Spine = require('spine')

class Contact extends Spine.Controller
  constructor: ->
    super
    @html(require('views/contact'))

module.exports = Contact
