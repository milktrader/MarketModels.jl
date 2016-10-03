VERSION >= v"0.4.0-dev+6521" && __precompile__(true)

module MarketModels

using TimeSeries, Distributions

# dev use only
using MarketData, TimeSeriesQueries, GaussianMixtures 

export simulate
export rday, ryear

###### include ##################

include("sim.jl")
include("const.jl")

end
