require('lib/setup')

Spine = require('spine')
$ = Spine.$
Spine.Route = require('spine/lib/route')

Pages = require('controllers/pages')

class App extends Spine.Controller
    constructor: ->
        super
        pages = new Pages(el: $('#app'))
        Spine.Route.setup()

module.exports = App
