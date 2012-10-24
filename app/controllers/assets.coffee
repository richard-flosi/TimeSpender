Spine = require('spine')
Asset = require('models/asset')

class AssetItem extends Spine.Controller
    tag: "tr"

    events:
        "click .remove": "remove"

    constructor: ->
        super
        throw "@item required" unless @item
        @item.bind("update", @render)

    render: =>
        @html(require('views/asset')(@item))
        @

    remove: ->
        @el.remove()
        @item.destroy()

class Assets extends Spine.Controller
    events:
        "click button.add": "addAsset"

    elements:
        "input.person": "person"
        "input.income": "income"
        "select.frequency": "frequency"
        "input.source": "source"
        "input.hours": "hours"
        "table.list": "list"

    constructor: ->
        super
        Asset.bind("create",  @addOne)
        Asset.bind("refresh", @addAll)
        Asset.fetch()
        @html(require('views/assets'))

    addAsset: =>
        asset = new Asset
            person: @person.val()
            income: @income.val()
            frequency: @frequency.val()
            source: @source.val()
            hours: @hours.val()
        asset.save()

    addOne: (item) =>
        asset = new AssetItem(item: item)
        @list.append(asset.render().el)

    addAll: =>
        Asset.each(@addOne)

module.exports = Assets
