% fitFilter2Data.m
% fit a filter to input-output time series
% minimal usage:
% [K, filtertime] = fitFilter2Data(stim, resp)
% 
% full usage:
% [K, filtertime] = fitFilter2Data(stim, resp,'filter_length',100,'reg',1,'normalise',false,'method','least-squares','offset',10);
% 
% created by Srinivas Gorur-Shandilya at 2:38 , 28 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [varargout] = fitFilter2Data(stim, resp, varargin)
if ~nargin && ~nargout
	help FitFilter2Data
	return
end

% options and defaults
options.filter_length = 1000;
options.reg = 1; % in units of mean of eigenvalues of C
options.normalise = true; % remove mean, divide through the std. dev.
options.method = 'least-squares';
options.offset = 0;
options.debug_mode = false;


if nargout && ~nargin 
	varargout{1} = options;
	return
end

% validate and accept options
options = corelib.parseNameValueArguments(options,varargin{:});

% defensive programming
assert(isvector(stim) && isvector(resp),'Stimulus and response should be vectors')
assert(length(stim)==length(resp),'stimulus and response vectors should be the same length');
% assert(~any(isnan(stim)),'Stimulus vector should not contain any NaN')
assert(~any(isinf(stim)),'Stimulus vector cannot contain Infinities')
assert(~any(isinf(resp)),'Response vector cannot contain Infinities')

% ensure column
stim = stim(:);
resp = resp(:);

% normalise
if options.normalise
	resp = resp - nanmean(resp);
	stim = stim - nanmean(stim(~isnan(resp)));
	resp = resp/nanstd(resp);
	stim = stim/nanstd(stim(~isnan(resp)));
end

% handle an offset, if any
if options.offset ~= 0 
	stim = [stim; NaN(options.offset,1)]; 
	resp = [NaN(options.offset,1); resp];
end
filtertime = (-options.offset+1:options.filter_length-options.offset);

switch options.method
	case {'transfer-function','tf'}
		K = ff_tfestimate(stim,resp,options.filter_length,options.reg);
	case {'least-squares','ls'}
		K = ff_leastsquares(stim,resp,options.filter_length,options.reg);
	case {'reverse-correlation','rc'}
		K = ff_revCorr(stim,resp,options.filter_length,options.reg);
end

switch nargout
case 0
	figure('outerposition',[0 0 800 800],'PaperUnits','points','PaperSize',[800 800]); hold on
	plot(filtertime,K,'k')
	xlabel('Fitler Lag (s)')
	ylabel('Filter')
	figlib.pretty();

case 1
	varargout{1} = K;
case 2
	varargout{1} = K;
	varargout{2} = filtertime;
end












        


