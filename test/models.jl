using MarketData
FactCheck.setstyle(:compact)
FactCheck.onlystats(true)

facts("models contruction works") do

    context("foo") do
        @fact true + true --> 2
    end
end
