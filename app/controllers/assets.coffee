Spine = require('spine')
Asset = require('models/asset')
Converters = require('lib/converters')

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

    addOne: (item) =>
        asset = new AssetItem(item: item)
        @list.append(asset.render().el)

    addAll: =>
        Asset.each(@addOne)

    updateSummary: =>
        incomePer =
            hour:  0
            day: 0
            week: 0
            month: 0
            year: 0

        hoursPer =
            hour: 0
            day: 0
            week: 0
            month: 0
            year: 0

        for asset in Asset.all()
            incomePer.hour += asset.income / asset.hours
            hoursPer.hour += asset.hours / Converters.hoursIn(asset.frequency)
            hoursPer.day += Converters.hoursIn('Day') / Converters.hoursIn(asset.frequency) * asset.hours
            hoursPer.week += Converters.hoursIn('Week') / Converters.hoursIn(asset.frequency) * asset.hours
            hoursPer.month += Converters.hoursIn('Month') / Converters.hoursIn(asset.frequency) * asset.hours
            hoursPer.year += Converters.hoursIn('Year') / Converters.hoursIn(asset.frequency) * asset.hours

        incomePer.hour = incomePer.hour / Asset.count()
        incomePer.day = incomePer.hour * hoursPer.day
        incomePer.week = incomePer.hour * hoursPer.week
        incomePer.month = incomePer.hour * hoursPer.month
        incomePer.year = incomePer.hour * hoursPer.year

        @incomePerHour.html('$' + Converters.toCurrency(incomePer.hour))
        @incomePerDay.html('$' + Converters.toCurrency(incomePer.day))
        @incomePerWeek.html('$' + Converters.toCurrency(incomePer.week))
        @incomePerMonth.html('$' + Converters.toCurrency(incomePer.month))
        @incomePerYear.html('$' + Converters.toCurrency(incomePer.year))

        @hoursPerHour.html(Converters.toTime(hoursPer.hour))
        @hoursPerDay.html(Converters.toTime(hoursPer.day))
        @hoursPerWeek.html(Converters.toTime(hoursPer.week))
        @hoursPerMonth.html(Converters.toTime(hoursPer.month))
        @hoursPerYear.html(Converters.toTime(hoursPer.year))

module.exports = Assets
