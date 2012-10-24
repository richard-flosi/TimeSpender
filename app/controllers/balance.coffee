Spine = require('spine')

class Balance extends Spine.Controller
  constructor: ->
    super
    @html(require('views/balance'))

module.exports = Balance
