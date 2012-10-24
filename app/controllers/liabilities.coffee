Spine = require('spine')
Liability = require('models/liability')

class LiabilityItem extends Spine.Controller
    tag: "tr"

    events:
        "click .remove": "remove"

    constructor: ->
        super
        throw "@item required" unless @item
        @item.bind("update", @render)

    render: =>
        @html(require('views/liability')(@item))
        @

    remove: ->
        @el.remove()
        @item.destroy()

class Liabilities extends Spine.Controller
    events:
        "click button.add": "addLiability"

    elements:
        "input.person": "person"
        "input.expense": "expense"
        "select.frequency": "frequency"
        "input.outlet": "outlet"
        "input.hours": "hours"
        "table.list": "list"

    constructor: ->
        super
        Liability.bind("create",  @addOne)
        Liability.bind("refresh", @addAll)
        Liability.fetch()
        @html(require('views/liabilities'))

    addLiability: =>
        liability = new Liability
            person: @person.val()
            expense: @expense.val()
            frequency: @frequency.val()
            outlet: @outlet.val()
            hours: @hours.val()
        liability.save()

    addOne: (item) =>
        liability = new LiabilityItem(item: item)
        @list.append(liability.render().el)

    addAll: =>
        Liability.each(@addOne)

module.exports = Liabilities
