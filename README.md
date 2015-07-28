# fitFilter2Data

This toolbox fits a linear filter to time series data with one input and one output. 

## Methods

1. Least Squares
2. Reverse Correlation
3. Fourier Transform

## Function Description

### [FindBestFilter.m](https://github.com/sg-s/fitFilter2Data/blob/master/FindBestFilter.m)
fits the "best" filter to data. a wrapper for FitFilter2Data
### [ff_leastsquares.m](https://github.com/sg-s/fitFilter2Data/blob/master/ff_leastsquares.m)
least-squares fit of filter to input-output data
### [ff_revCorr.m](https://github.com/sg-s/fitFilter2Data/blob/master/ff_revCorr.m)
extracts filter from input vector x and output vector y using reverse correlation methods 
### [ff_tfestimate.m](https://github.com/sg-s/fitFilter2Data/blob/master/ff_tfestimate.m)
uses inverse fourier transform of Transfer function to reconstruct filter
### [fitFilter2Data.m](https://github.com/sg-s/fitFilter2Data/blob/master/fitFilter2Data.m)
fit a filter to input-output time series
