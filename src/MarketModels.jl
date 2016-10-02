VERSION >= v"0.4.0-dev+6521" && __precompile__(true)

module MarketModels

using TimeSeries, Distributions
# dev use only
using MarketData, TimeSeriesQueries 

export true_statement, dev

###### include ##################

include("models.jl")
include("dev.jl")

end
