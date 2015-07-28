% fitFilter2Data.m
% fit a filter to input-output time series
% 
% created by Srinivas Gorur-Shandilya at 2:38 , 28 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [K, C] = fitFilter2Data(stim, resp, varargin)
if ~nargin
	help FitFilter2Data
	return
end

% defaults
filter_length = 1000;
reg = NaN; % in units of mean of eigenvalues of C
normalise = true; % remove mean, divide through the std. dev.
method = 'transfer-function';

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




% check that stimulus and resp are OK

if isvector(stim) && isvector(resp)
	% stimulus and resp are both vectors, so do it the easy way

	% ensure column
	stim = stim(:);
	resp = resp(:);

	% throw out NaNs
	rm_this = isnan(stim) | isnan(resp);
	stim(rm_this) = [];
	resp(rm_this) = [];

	% check that there are no Infs
	if sum(isinf(stim)) || sum(isinf(resp))
		error('Inf in inputs/outputs, cannot continue')
	end

	% normalise
	if normalise
		resp = resp - mean(resp);
		stim = stim - mean(stim);
		resp = resp/std(resp);
		stim =  stim/std(stim);
	end

	switch method
		case {'transfer-function','tf'}
			K = ff_tfestimate(stim,resp,filter_length,reg);
		case {'least-squares','ls'}
			K = ff_leastsquares(stim,resp,filter_length,reg);
		case {'reverse-correlation','rc'}
			K = ff_revCorr(stim,resp,filter_length,reg);
	end


else
	error('Stimulus or response is not a vector, cannot continue. Fitting multiple datasets? Use the OnlyThesePoints option. ')

end














        


