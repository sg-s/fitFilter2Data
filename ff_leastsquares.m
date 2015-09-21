% ff_leastsquares.m
% least-squares fit of filter to input-output data
%
% created by Srinivas Gorur-Shandilya at 2:52 , 28 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
	
function [K] = ff_leastsquares(stim,resp,filter_length,reg)

% read pref file
pref = readPref(which(mfilename));

% throw away parts of the response for which we don't care
only_these_points = find(~isnan(resp));
only_these_points(only_these_points<filter_length+1) = []; % we can't use this bit

% if there is an offset, we introduced some NaNs into the stim
if any(isnan(stim))
    only_these_points(only_these_points>find(~isnan(stim),1,'last')) = [];
    if pref.debug_mode
        disp('ff_leastsquares::NaNs in stim, throwing some stuff out')
    end
else
    
end

resp = resp(only_these_points);


% chop up the stimulus into blocks  
s = zeros(length(only_these_points), filter_length);

for i = 1:length(only_these_points)
	s(i,:) = stim(only_these_points(i):-1:only_these_points(i)-filter_length+1);
end

% compute covariance matrix
C = s'*s; % this is the covariance matrix, scaled by the size of the C
% scale reg by mean of eigenvalues

% determine condition parameter 
c = cond(C);
oldC = C;
if isnan(reg)
    if pref.debug_mode
        disp('ff_leastsquares::No regularisation factor provided, will try to figure this out on my own...')
    end
    if c < length(C)
    	if pref.debug_mode
            disp('ff_leastsquares::covariance matrix is well conditioned. Will not try to regularise')
        end
    	r = 0;
    else
    	if pref.debug_mode
            disp('ff_leastsquares::Covariance matrix badly conditioned. Will perform a binary search for the best condition number...')
        end
    	rmin = 0;
    	rmax = 1/(2*eps);
    	r = c;
    	for i = 1:100
    		C = oldC + eye(length(C))*r;
    		c = cond(C);
    		if c < length(C)
    			% decrease r
    			rmax = r;
    			r = mean([rmin r]);
    		else
    			% increase r
    			rmin = r;
    			r = mean([rmax r]);
    		end
    		
    	end
    end
    if pref.debug_mode
        disp('ff_leastsquares::the best regularisation factor I found was:')
        disp(r)
    end
    C = oldC + eye(length(C))*r;
else
    if pref.debug_mode
        disp('ff_leastsquares::Regularisation factor specified. Scaling by the mean eigenvalue...')
    end
	MeanEigenValue = trace(C)/length(C); % cheat; this is the same as mean(eig(C))
	r = reg*MeanEigenValue;
    C = (C + r*eye(length(C)))*trace(C)/(trace(C) + r*length(C));
end

K = C\(s'*resp);