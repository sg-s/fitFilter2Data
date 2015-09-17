% ff_leastsquares.m
% least-squares fit of filter to input-output data
%
% created by Srinivas Gorur-Shandilya at 2:52 , 28 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
	
function [K] = ff_leastsquares(stim,resp,filter_length,reg,OnlyThesePoints)

% throw away parts of the response for which we don't care
resp = resp(OnlyThesePoints);

if length(OnlyThesePoints) == length(stim)
    OnlyThesePoints = find(OnlyThesePoints);
end

% chop up the stimulus into blocks  
s = zeros(length(OnlyThesePoints), filter_length+1);

for i=2:length(OnlyThesePoints)
	s(i,:) = stim(OnlyThesePoints(i):-1:OnlyThesePoints(i)-filter_length);
end

% compute covariance matrix
C = s'*s; % this is the covariance matrix, scaled by the size of the C
% scale reg by mean of eigenvalues


% determine condition parameter 
c = cond(C);
oldC = C;
if isnan(reg)
    if c < length(C)
    	% all OK
    	r = 0;
    else
    	% use a binary search to find the best value to regularise by
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
    C = oldC + eye(length(C))*r;
else
	MeanEigenValue = trace(C)/length(C); % cheat; this is the same as mean(eig(C))
	r = reg*MeanEigenValue;
    C = (C + r*eye(length(C)))*trace(C)/(trace(C) + r*length(C));
end

K = C\(s'*resp);