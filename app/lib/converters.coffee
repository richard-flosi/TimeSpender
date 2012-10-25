Converters =
    hoursIn: (frequency) ->
        switch frequency
            when "Hour" then 1
            when "Day" then 24
            when "Week" then 168
            when "Month" then 730.484
            when "Year" then 8765.81

    fromHours: (to, num) ->
        switch to
            when "Hour" then num
            when "Day" then num * 24
            when "Week" then num * 168
            when "Month" then num * 730.484
            when "Year" then num * 8765.81

    toCurrency: (num) ->
        num.toFixed(2).toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ",")

    toTime: (hours) ->
        hours.toFixed(2)

module.exports = Converters
