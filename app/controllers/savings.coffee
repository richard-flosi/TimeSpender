Spine = require('spine')

class Savings extends Spine.Controller
  constructor: ->
    super
    @html(require('views/savings'))

module.exports = Savings
