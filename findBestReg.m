% findBestReg.m
% finds the best regularisation factor using cross-validation on the data
% usage:
% [K, filtertime] = findBestReg(stim, resp)
% 
% full usage:
% [K, filtertime] = findBestReg(stim, resp,'filter_length',100,reg,1,'normalise',false,'offset',10);
% 
% findBestReg defaults to using the least squares method.
% 
% created by Srinivas Gorur-Shandilya at 4:21 , 12 October 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [K,filtertime] = findBestReg(stim,resp,varargin)

if ~nargin
	help FitFilter2Data
	return
end

% defaults
filter_length = 1000;
reg = 1; % in units of mean of eigenvalues of C
normalise = true; % remove mean, divide through the std. dev.
method = 'least-squares';
offset = 0;
nsteps = 30;

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
% assert(~any(isnan(stim)),'Stimulus vector should not contain any NaN')
assert(~any(isinf(stim)),'Stimulus vector cannot contain Infinities')
assert(~any(isinf(resp)),'Response vector cannot contain Infinities')

% ensure column
stim = stim(:);
resp = resp(:);

% split the data into two -- training and test
sp = floor(length(stim)/2);
test_stim = stim(1:sp);
test_resp = stim(1:sp);

stim = stim(sp:end);
resp = resp(sp:end);

err = ones(nsteps,1);

reg_max = 1e3;
reg_min = 1e-3;
reg = reg*ones(nsteps,1);

for i = 1:nsteps
	% disp(i)
	% disp([reg_min reg_max])
	% get filter using this reg
	[K, filtertime] = fitFilter2Data(stim, resp,'filter_length',filter_length,'reg',reg(i),'normalise',normalise,'offset',offset,'method','least-squares');
	test_pred = convolve(1:length(test_stim),test_stim,K,filtertime);
	err(i) = 1 - rsquare(test_pred,test_resp);

	if i == 1
		reg(i+1) = reg(i)*2;
	end

	if i > 1
		if err(i) - err(i-1) > 0
			% disp('errors increasing')
			% so reverse whatever you were doing
			delta_reg = reg(i) - reg(i-1);
			if delta_reg > 0
				% disp('reg was increasing. so will decrease now')
				reg(i+1) = exp((log(reg(i)) + log(reg_min))/2);
				reg_max = reg(i);
			else
				% disp('reg was decreasing. so will increase now')
				reg(i+1) = exp((log(reg(i)) + log(reg_max))/2);
				reg_min = reg(i);
			end
		else
			% disp('errors decreasing ')
			% so keep doing whatever you were doing
			delta_reg = reg(i) - reg(i-1);
			if delta_reg > 0
				% disp('reg was increasing')
				reg(i+1) = exp((log(reg(i)) + log(reg_max))/2);
				reg_min = reg(i);
			else
				% disp('reg was decreasing')
				reg(i+1) = exp((log(reg(i)) + log(reg_min))/2);
				reg_max = reg(i);
			end

		end
	end

	if (reg_max - reg_min) < 1
		return
	end

end

% disp('Best reg was:')
% disp(reg(end))






