Motivation
==========

Market models have existed almost as long as markets have. Pattern observations based on price momentum, candle-stick sequences, 
time and sales data, and many other methods are used to model markets but all with the expressed purpose of being able to predict
their movement. This speaks to the very human desire to leverage knowledge to build wealth. By predicting markets, one is poised
to take market positions ahead of their movements to profit once the move has materilized.

Besides on-the-spot market models such as those already listed, there is another field of reasearch that backtests existing market
data, with varying in-sample, out-sample regmimes, with the expressed purpose of devising a system of trading. The most common example
of a trading system would be to buy when the 50-period moving average of price is above the 200-period moving average, and to sell when
the opposite condition is true. Most current backtesting platforms use market prices, which are not i.i.d., to derive results from their
strategy being played out in historical data.

MarketModels takes a diffewrent approach to modeling markets that uses market returns, or the simple (or log) difference between 
consequetive prices. These returns are represented as percent change.

The motivation behind using returns versus prices is founded in the simple observation that i.i.d (or nearly so) data is easier to model
and to make assumptions about than data that is not such.

Modeling returns is nothing new. Putting them into a Gaussian distribution is also nothing new. But this practice often involves quite a
bit of hand-waving about what to do with the fact that fat-tails exist in nearly all markets. MarketModels assumes that using a simple
Gaussian model simply does more harm than good. Of course all models are wrong, but we hope that some are useful. Simple Gaussian modeling
is not only useless, its dangerously naive.

MarketModels builds models from returns in what is known as a Mixture Model, or a model that sums unique distributions to arrive at a 
single model. What to do with this model is left to the user, and caution is advised. Remember, all models are wrong.
