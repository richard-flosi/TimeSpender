Spine = require('spine')
Asset = require('models/asset')
Converters = require('lib/converters')
hoursIn = Converters.hoursIn
fromHours = Converters.fromHours

class Liability extends Spine.Model
    @configure 'Liability', 'person', 'expense', 'frequency', 'activity', 'order'
    @extend Spine.Model.Local

    @expensePer =
        hour:  0
        day: 0
        week: 0
        month: 0
        year: 0

    @hoursPer =
        hour: 0
        day: 0
        week: 0
        month: 0
        year: 0

    @summarize: =>
        @expensePer =
            hour:  0
            day: 0
            week: 0
            month: 0
            year: 0

        @hoursPer =
            hour: 0
            day: 0
            week: 0
            month: 0
            year: 0

        for liability in @.all()
            @expensePer.hour += liability.expense / hoursIn(liability.frequency)

        @expensePer.day   = fromHours('Day',   @expensePer.hour)
        @expensePer.week  = fromHours('Week',  @expensePer.hour)
        @expensePer.month = fromHours('Month', @expensePer.hour)
        @expensePer.year  = fromHours('Year',  @expensePer.hour)

        @hoursPer.hour  = @expensePer.hour  / Asset.incomePer.hour
        @hoursPer.day   = @expensePer.day   / Asset.incomePer.hour
        @hoursPer.week  = @expensePer.week  / Asset.incomePer.hour
        @hoursPer.month = @expensePer.month / Asset.incomePer.hour
        @hoursPer.year  = @expensePer.year  / Asset.incomePer.hour

module.exports = Liability
