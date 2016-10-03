A Smarter Model
===============

There are many things we can do to improve out model. We can perhaps train it better. That won't hurt to do, 
but there will be a limit to its benefit and it will be realized fairy quickly. 

In classical time series analysis, there are tools we can use to determine serial correlation as well as
conditional heteroskedasticity. Our model does not __yet__ incoroprate these important tools. So far, we've
simply stepped away from a simplistic Gaussian model of returns to a more realistic mixed model of Gaussian
returns.

Let's take serial correlation first. This will involve some persuading of the random draw mechanism to take
samples that are within the range of serial correlation that we observe. To understand this component, we'll
need to create a separate model of serial correlation, and then find a way for it to pursuade the selection
of returns from our modeled distribution.

To create this model, we will use ``arima`` methods found in the TimeModels package.

Besides acknowledging serial correlation, it's also important to account for volatility spikes that often happen
in time series data. This is a separate model and will involve ``garch`` methods, also found in the TimeModels
package.

While the serial correlation model will attempt to persuade local draws, the garch model will pursuade the random
selection algorithm to take periodic trips to the fat tails regions.
