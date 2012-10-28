Spine = require('spine')
Asset = require('models/asset')
Converters = require('lib/converters')
toCurrency = Converters.toCurrency
toTime = Converters.toTime

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
        Asset.trigger("change")

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
        "table.summary td.income.hour": "incomePerHour"
        "table.summary td.income.day": "incomePerDay"
        "table.summary td.income.week": "incomePerWeek"
        "table.summary td.income.month": "incomePerMonth"
        "table.summary td.income.year": "incomePerYear"
        "table.summary td.hours.hour": "hoursPerHour"
        "table.summary td.hours.day": "hoursPerDay"
        "table.summary td.hours.week": "hoursPerWeek"
        "table.summary td.hours.month": "hoursPerMonth"
        "table.summary td.hours.year": "hoursPerYear"

    constructor: ->
        super
        @html(require('views/assets'))
        Asset.bind("create",  @addOne)
        Asset.bind("refresh", @addAll)
        Asset.bind("create refresh change", @updateSummary)
        Asset.fetch()

    addAsset: =>
        asset = new Asset
            person: @person.val()
            income: @income.val()
            frequency: @frequency.val()
            source: @source.val()
            hours: @hours.val()
        asset.save()

        @person.val('')
        @income.val('')
        @frequency.val('')
        @source.val('')
        @hours.val('')

    addOne: (item) =>
        asset = new AssetItem(item: item)
        @list.append(asset.render().el)

    addAll: =>
        Asset.each(@addOne)

    updateSummary: =>
        Asset.summarize()

        @incomePerHour.html('$' + toCurrency(Asset.incomePer.hour))
        @incomePerDay.html('$' + toCurrency(Asset.incomePer.day))
        @incomePerWeek.html('$' + toCurrency(Asset.incomePer.week))
        @incomePerMonth.html('$' + toCurrency(Asset.incomePer.month))
        @incomePerYear.html('$' + toCurrency(Asset.incomePer.year))

        @hoursPerHour.html(toTime(Asset.hoursPer.hour))
        @hoursPerDay.html(toTime(Asset.hoursPer.day))
        @hoursPerWeek.html(toTime(Asset.hoursPer.week))
        @hoursPerMonth.html(toTime(Asset.hoursPer.month))
        @hoursPerYear.html(toTime(Asset.hoursPer.year))

module.exports = Assets
