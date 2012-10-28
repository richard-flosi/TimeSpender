Spine = require('spine')

class Investments extends Spine.Controller
  constructor: ->
    super
    @html(require('views/investments'))

module.exports = Investments
