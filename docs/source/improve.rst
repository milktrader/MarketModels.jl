A Smarter Model
===============

There are many things we can do to improve out model. Perhaps a better fit would help. Maybe incorporate
some classic time series tools such as arima and garch to improve realistic random draws. Or we could
even define market states based on technical indicators, and create models for each state.

More Training
-------------

We can perhaps train our model better. Optimization is outside the scope of this discussion, but at the very
least some effort can be made in this area.

Classic Tools
-------------

In classical time series analysis, there are several tools we can use to overlay on our basic model. The two most
common tools include ARIMA and GARCH. ARIMA measures serial correlation while GARCH is used to identify volatility
spikes.

How these tools are integreated with our basic model is left to the user, but clearly this will involve some persuading 
of the random draw mechanism to take samples that are within the range of the serial correlation that we observe or
to take periodic trips to the fat tails regions.

Market States
-------------

Many market observers like to classify markets as with being bullish or bearish. Bullish indicates that there
are overwhelmingly more positive returns, and bearish is the opposite.

A possible way to model markets is to create separate models for each state, and to take random draws from
the model that corresponds to the current market state.
