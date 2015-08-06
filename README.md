# fitFilter2Data

This MATLAB toolbox fits a linear filter to time series data with one input and one output. 

## Requirements

1. MATLAB 

## Installation

The recommended way to install `fitFilter2Data` is to use my package manager:

```matlab
>> urlwrite('http://srinivas.gs/install.m','install.m'); 
>> install fitFilter2Data
>> install srinivas.gs_mtools
```

if you have git installed, you can

```bash
git clone https://github.com/sg-s/fitFilter2Data
git clone https://github.com/sg-s/srinivas.gs_mtools # fitFilter2Data needs this to work
```

and don't forget to add these folders to your MATLAB path

## Methods

1. Least Squares
2. Reverse Correlation
3. Fourier Transform

## Function Description

What follows is a machine-generated summary of what each function in this repository does. For more detailed descriptions, try `help functionName`

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

## License 

[GPL](http://choosealicense.com/licenses/gpl-2.0/#)
