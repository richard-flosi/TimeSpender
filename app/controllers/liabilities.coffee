Spine = require('spine')
Asset = require('models/asset')
Liability = require('models/liability')
Converters = require('lib/converters')
toCurrency = Converters.toCurrency
toTime = Converters.toTime

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
        Liability.trigger("change")

class Liabilities extends Spine.Controller
    events:
        "click button.add": "addLiability"

    elements:
        "input.person": "person"
        "input.expense": "expense"
        "select.frequency": "frequency"
        "input.activity": "activity"
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
            activity: @activity.val()
            hours: @hours.val()
        liability.save()

        @person.val('')
        @expense.val('')
        @frequency.val('')
        @activity.val('')
        @hours.val('')

    addOne: (item) =>
        liability = new LiabilityItem(item: item)
        @list.append(liability.render().el)

    addAll: =>
        Liability.each(@addOne)

    updateSummary: =>
        Liability.summarize()

        @expensePerHour.html('$' + toCurrency(Liability.expensePer.hour))
        @expensePerDay.html('$' + toCurrency(Liability.expensePer.day))
        @expensePerWeek.html('$' + toCurrency(Liability.expensePer.week))
        @expensePerMonth.html('$' + toCurrency(Liability.expensePer.month))
        @expensePerYear.html('$' + toCurrency(Liability.expensePer.year))

        @hoursPerHour.html(toTime(Liability.hoursPer.hour))
        @hoursPerDay.html(toTime(Liability.hoursPer.day))
        @hoursPerWeek.html(toTime(Liability.hoursPer.week))
        @hoursPerMonth.html(toTime(Liability.hoursPer.month))
        @hoursPerYear.html(toTime(Liability.hoursPer.year))

module.exports = Liabilities
