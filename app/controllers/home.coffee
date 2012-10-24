Spine = require('spine')

class Home extends Spine.Controller
  constructor: ->
    super
    @html(require('views/home'))

module.exports = Home
