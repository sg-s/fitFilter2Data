% fitFilter2Data.m
% fit a filter to input-output time series
% 
% created by Srinivas Gorur-Shandilya at 2:38 , 28 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [K, filtertime] = fitFilter2Data(stim, resp, varargin)
if ~nargin
	help FitFilter2Data
	return
end

% defaults
filter_length = 1000;
reg = NaN; % in units of mean of eigenvalues of C
normalise = true; % remove mean, divide through the std. dev.
method = 'least-squares';
offset = 0;

% evaluate optional inputs
if iseven(nargin)
	for ii = 1:2:length(varargin)-1
    	temp = varargin{ii};
    	if ischar(temp)
        	eval(strcat(temp,'=varargin{ii+1};'));
    	end
	end
else
    error('Inputs need to be name value pairs')
end

% read pref file
pref = readPref(which(mfilename));

% defensive programming
assert(isvector(stim) && isvector(resp),'Stimulus and response should be vectors')
assert(length(stim)==length(resp),'stimulus and response vectors should be the same length');
assert(~any(isnan(stim)),'Stimulus vector should not contain any NaN')
assert(~any(isinf(stim)),'Stimulus vector cannot contain Infinities')
assert(~any(isinf(resp)),'Response vector cannot contain Infinities')

% ensure column
stim = stim(:);
resp = resp(:);

% normalise
if normalise
	resp = resp - nanmean(resp);
	stim = stim - mean(stim);
	resp = resp/nanstd(resp);
	stim = stim/std(stim);
end

% handle an offset, if any
if offset ~= 0 
	stim = [stim; NaN(offset,1)]; 
	resp = [NaN(offset,1); resp];
end
filtertime = [-offset+1:filter_length-offset];

switch method
	case {'transfer-function','tf'}
		K = ff_tfestimate(stim,resp,filter_length,reg);
	case {'least-squares','ls'}
		K = ff_leastsquares(stim,resp,filter_length,reg);
	case {'reverse-correlation','rc'}
		K = ff_revCorr(stim,resp,filter_length,reg);
end














        


