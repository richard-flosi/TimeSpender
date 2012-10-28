Spine = require('spine')
$ = Spine.$
hoursIn = require('lib/converters').hoursIn

class Asset extends Spine.Model
    @configure 'Asset', 'person', 'income', 'frequency', 'source', 'hours', 'order'
    @extend Spine.Model.Local

    @incomePer =
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
        @incomePer =
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

        for asset in @.all()
            @incomePer.hour += asset.income / asset.hours
            @hoursPer.hour  += asset.hours / hoursIn(asset.frequency)
            @hoursPer.day   += hoursIn('Day') / hoursIn(asset.frequency) * asset.hours
            @hoursPer.week  += hoursIn('Week') / hoursIn(asset.frequency) * asset.hours
            @hoursPer.month += hoursIn('Month') / hoursIn(asset.frequency) * asset.hours
            @hoursPer.year  += hoursIn('Year') / hoursIn(asset.frequency) * asset.hours

        @incomePer.hour  = @incomePer.hour / @.count()
        @incomePer.day   = @incomePer.hour * @hoursPer.day
        @incomePer.week  = @incomePer.hour * @hoursPer.week
        @incomePer.month = @incomePer.hour * @hoursPer.month
        @incomePer.year  = @incomePer.hour * @hoursPer.year

module.exports = Asset
