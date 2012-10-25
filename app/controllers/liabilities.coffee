Spine = require('spine')
Asset = require('models/asset')
Liability = require('models/liability')
Converters = require('lib/converters')

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
        "table.summary td.expense.hour": "expensePerHour"
        "table.summary td.expense.day": "expensePerDay"
        "table.summary td.expense.week": "expensePerWeek"
        "table.summary td.expense.month": "expensePerMonth"
        "table.summary td.expense.year": "expensePerYear"
        "table.summary td.hours.hour": "hoursPerHour"
        "table.summary td.hours.day": "hoursPerDay"
        "table.summary td.hours.week": "hoursPerWeek"
        "table.summary td.hours.month": "hoursPerMonth"
        "table.summary td.hours.year": "hoursPerYear"

    constructor: ->
        super
        @html(require('views/liabilities'))
        Liability.bind("create",  @addOne)
        Liability.bind("refresh", @addAll)
        Liability.bind("create refresh change", @updateSummary)
        Liability.fetch()

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

    updateSummary: =>
        expensePer =
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

        rate =
            hourly: 0

        for asset in Asset.all()
            rate.hourly += asset.income / asset.hours
        rate.hourly = rate.hourly / Asset.count()

        for liability in Liability.all()
            expensePer.hour += liability.expense / Converters.hoursIn(liability.frequency)

        expensePer.day = Converters.fromHours('Day', expensePer.hour)
        expensePer.week = Converters.fromHours('Week', expensePer.hour)
        expensePer.month = Converters.fromHours('Month', expensePer.hour)
        expensePer.year = Converters.fromHours('Year', expensePer.hour)

        hoursPer.hour = expensePer.hour / rate.hourly
        hoursPer.day = expensePer.day / rate.hourly
        hoursPer.week = expensePer.week / rate.hourly
        hoursPer.month = expensePer.month / rate.hourly
        hoursPer.year = expensePer.year / rate.hourly

        @expensePerHour.html('$' + Converters.toCurrency(expensePer.hour))
        @expensePerDay.html('$' + Converters.toCurrency(expensePer.day))
        @expensePerWeek.html('$' + Converters.toCurrency(expensePer.week))
        @expensePerMonth.html('$' + Converters.toCurrency(expensePer.month))
        @expensePerYear.html('$' + Converters.toCurrency(expensePer.year))

        @hoursPerHour.html(Converters.toTime(hoursPer.hour))
        @hoursPerDay.html(Converters.toTime(hoursPer.day))
        @hoursPerWeek.html(Converters.toTime(hoursPer.week))
        @hoursPerMonth.html(Converters.toTime(hoursPer.month))
        @hoursPerYear.html(Converters.toTime(hoursPer.year))

module.exports = Liabilities
