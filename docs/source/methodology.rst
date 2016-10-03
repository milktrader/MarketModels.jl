Methodology
===========

The modeling in MarketModels begins with period returns. These returns can be either simple or logarithmic; it's 
left to the user to decide which is better suited for modeling. Though many markets exhibit a Gaussian distribution
with fat tails (resulting in three humps), this might not always be the case. It is best to plot the returns as
either a kernel density plot or histogram to get a feel for how many bulges are formed in the posterior. Assuming
we have a typical three-humped distribution, we can select that parameter in the initial fit.

To fit our returns into a complex distribution, we use the GaussianMixtures package. This package allows for the
fitting process nicely and the API is easily understood::

    my_fit = GMM(3, returns_vector, method=:kmeans, nInit=50, nIter=10)

A few notes about this initial fit. First, the first argument represents how many humps we visualize in our data.
The second argument, named ``returns_vector``, is a Float64 array of return values that we would typically extract
from a TimeSeries.TimeArray object (ie, ``returns_vector = my_returns.values``). The ``method`` argument, ``nInit``
and ``nIter`` arguments are self-explanatory.

The ``my_fit`` variable defined above is next passed into a ``MixedModel`` from the Distributions package.::

    my_model = MixedModel(my_fit)

Once ``my_model`` is defined, random draws are avaiable. In this basic approach, the model will likely provide decent
values, as long as the number of draws stays small, as in under 10. Once a large number of draws is taken, the model
as defined above will begin to wildly diverge from historical prices and care should be taken by the modeler to monitor
the random draw values.

Simply Genius!
--------------

First the good news. Let's take some historical data from the MarketData package and create a model as described above.::

    using MarketData, TimeSeries, TimeSeriesQueries

    gen_op(CAT)

    c = @select CAT where close
    
    ret = percentchange(c)

    vals = ret.values

    using GaussianMixtures

    my_fit = GMM(3, vals, method=:kmeans, nInit=50, nIter=10)

    my_model = MixedModel(my_fit)

Now that we have the pieces in place, let's simulate prices from our model and compare them from simulated prices from
the historical data. The ``simulate`` method below accepts an array of ``Float64`` values. 

We get that from historical data by simply passing in the ``vals`` variable. We can slice the ``vals`` variable by 
passing a range to the array (ie, ``vals[1:10]``).

To get random draws from our model, we take an equal number of draws using the ``rand`` method (ie, ``rand(my_model, 10)``.

Let's compare our model's output to the historical record. Since these draws are random and we haven't seeded the RNG, 
you will get different values than this example.::

    draws = ones(10,10);

    for s in 1:10 
        draws[:,s] = simulate(rand(my_model, 10))
    end

    draws

    10×10 Array{Float64,2}:
     101.758   100.052   100.053   100.048  100.055   98.2736  100.061  100.053  98.2883  100.057 
     101.813   100.112   101.806   100.112  101.83    96.5911  100.119  100.115  98.3392   98.3554
     101.865    98.3916  100.058   100.169  103.613   98.302   100.171  100.165  96.6535  100.094 
     100.113   100.12     98.3676  101.956  101.843  100.013   101.936  101.946  96.7041  100.144 
     100.166    98.4122   98.4175  100.211  100.089  101.766   103.716  102.001  96.7571   98.4081
     100.224   100.112   100.159   100.269  100.15   101.825   103.78   102.065  96.814   100.157 
     100.281    98.3733   98.4366  100.323  101.89   103.624   105.655  102.127  98.5367   98.4478
      98.5379   98.4249  100.186   100.379  101.949  103.673   107.508  103.891  96.8252  100.154 
     100.266    98.4778   98.4337  102.176  100.214  105.506   107.568  103.948  98.5562  100.208 
     100.319   100.192    98.4832  103.979  101.96   107.332   109.44   104.012  96.8302  100.269 

Compare this to what ``simulate`` would do from a random section of historical data. Below we take 13,001 
through 13,010 observations::

    simulate(vals[13001:13010])

    10-element Array{Float64,1}:
       99.6066
       98.5815
       98.2835
       98.3788
       98.3907
       98.355 
       99.5828
       98.8795
       99.404 
      102.026

Alright, so not too shabby. Nothing crazy in how our model generated prices as compared to actual historical       
prices. Of all ten draws, none were wildly out of place. But the picture doesn't look so nice when we take a 
larger number of draws.

When Genius Fails
-----------------

Let's take all the values from the ``vals`` array and see what happens at the end. Remember, this is the actual, 
historical data taken from 1962 to 2013.::

    simulate(vals)

    13089-element Array{Float64,1}:
     100.961
     103.584
     104.545
     105.195
     106.182
     104.857
     106.494
     107.143
     106.805
     105.195
     104.857
     107.143
     109.091
     108.753
     106.494
     105.844
     106.494
     ⋮    
     222.078
     223.61 
     224.468
     221.506
     222.26 
     223.506
     226.961
     225.766
     229.013
     227.377
     230.987
     233.662
     236.13 
     236.753
     236.026
     236.026
     235.87 

Like we did above, let's simulate 10 separate draws from out model. This will generate a lot of numbers, but it's 
useful to view it and see how close to historical we get.::

    draws = ones(13089,10);

    for s in 1:10 
        draws[:,s] = simulate(rand(my_model, 13089))
    end

    draws

    13089×10 Array{Float64,2}:
     100.05      100.054    101.742   100.052   101.759    98.3049    98.2918   100.054    100.059    100.061 
     100.101     100.113    101.804    98.3203  101.823    98.3595    98.3476   101.795     98.324    100.118 
      98.3862    101.889    103.549   100.058   103.584    98.4182    98.4026   103.595     96.6419    98.402 
      98.4447    103.676    105.378    98.3096  101.777    96.722     98.462    105.415     98.3471    98.4642
     100.17      101.887    103.569    98.3601  103.563    98.4476    98.525    107.278     98.4045    98.5175
      98.4479    103.668    103.623   100.03    103.621    96.7168    98.5772   105.419     96.6915   100.247 
      98.5086    101.865    105.424   100.085   101.847    95.0631   100.297    103.609     96.7455   100.301 
      96.802     103.693    107.273    98.362   101.911    95.1236   102.059    101.812     98.4395    98.5811
      95.1489    105.566    105.423    96.6547  101.971    93.5009   100.299    100.043    100.171     98.6427
      95.2001    107.392    105.481    96.7141  100.23     93.5492   100.366    100.098     98.4828   100.384 
      95.2529    107.451    103.696    96.7677  100.286    91.9454   102.115     98.3808    98.5397   102.151 
      93.583     107.511    105.54     98.4771  102.01     91.9916   102.169    100.084     96.8394   103.979 
      95.2395    107.566    105.61     96.81    103.815    90.3882   102.223    100.147     96.8938   104.037 
      93.6117    107.624    105.67     95.1204  102.042    90.4377   102.283    100.205     98.5397   104.094 
      93.6645    107.685    105.726    93.4802  102.106    88.8791   104.064    101.948     98.5957   102.311 
      95.3195    109.56     105.781    93.5328  102.168    88.9311   105.917    102.006     96.8931   102.363 
      95.373     109.629    105.836    95.1576  103.97     87.4206   104.112    103.774     98.607    102.414 
       ⋮                                                    ⋮                                                 
    6621.38    35923.9    12665.6    1937.99    257.213  1321.47    5800.05    4057.66    7699.14    2193.87  
    6508.14    35942.2    12673.8    1904.76    252.752  1322.16    5803.51    4130.01    7703.31    2232.3   
    6623.58    35960.0    12897.3    1905.83    252.9    1299.35    5806.59    4201.85    7838.53    2233.43  
    6739.98    36589.1    13122.1    1939.22    257.284  1277.22    5810.11    4204.25    7702.46    2194.83  
    6743.58    37225.7    12898.0    1940.26    261.727  1277.94    5909.84    4278.37    7706.74    2233.04  
    6863.28    37246.0    12906.3    1974.02    266.431  1278.68    5806.74    4353.13    7841.79    2272.69  
    6983.33    36605.1    13135.2    1975.29    266.577  1279.38    5707.34    4355.53    7707.7     2312.65  
    6863.09    36622.1    13143.7    1976.48    261.971  1257.09    5710.51    4358.16    7574.36    2352.49  
    6867.0     36643.8    13376.3    1977.54    262.101  1278.89    5714.13    4360.66    7578.57    2394.05  
    6750.52    36666.2    13612.4    2012.46    262.237  1256.89    5615.09    4363.14    7583.52    2435.72  
    6866.16    36036.5    13383.8    2013.51    262.378  1235.06    5714.78    4439.96    7717.59    2393.27  
    6870.1     36686.4    13392.1    2014.74    262.538  1214.0     5616.23    4442.35    7851.76    2435.11  
    6988.24    36058.6    13400.3    2015.77    262.693  1214.64    5619.93    4365.07    7856.29    2477.57  
    6992.14    36079.2    13166.6    1981.05    262.848  1236.26    5718.0     4367.56    7719.67    2478.99  
    6870.82    35457.1    13173.0    1982.11    267.498  1215.09    5620.79    4369.92    7585.85    2435.92  
    6874.85    35475.9    12943.2    2017.15    267.66   1236.3     5717.55    4372.51    7454.52    2437.46  
    6754.65    35490.9    12950.4    2018.28    263.069  1258.27    5817.74    4298.11    7458.76    2394.79  
    
Only one of the 10 draws came close to modeling our historical prices, and all the rest of them were off by a magnitude
of 10 to 70. 
        



