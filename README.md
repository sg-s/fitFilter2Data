# fitFilter2Data

This MATLAB toolbox fits a linear filter to time series data with one input and one output. 

## Requirements

1. MATLAB 

## Installation

The recommended way to install `fitFilter2Data` is to use my package manager:

```matlab
% copy any paste this into your matlab prompt
urlwrite('http://srinivas.gs/install.m','install.m'); 
install fitFilter2Data
install srinivas.gs_mtools
```

if you have git installed, you can

```bash
# copy and paste this into your bash prompt
git clone https://github.com/sg-s/fitFilter2Data
git clone https://github.com/sg-s/srinivas.gs_mtools # fitFilter2Data needs this to work
```

and don't forget to add these folders to your MATLAB path

## Tests

You can run tests on this to check that everything is working by using 

```matlab
makePDF('tests.m')
```

## Hacking

Active development occurs on the `dev` branch. PRs welcome. 

## License 

[GPL](http://choosealicense.com/licenses/gpl-2.0/#)
