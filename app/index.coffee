require('lib/setup')

Spine = require('spine')
$ = Spine.$
Assets = require('controllers/assets')
Liabilities = require('controllers/liabilities')

class App extends Spine.Controller
    constructor: ->
        super
        @assets = new Assets(el: $("#assets"))
        @liabilities = new Liabilities(el: $("#liabilities"))

module.exports = App
