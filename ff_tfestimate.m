% ff_tfestimate.m
% uses inverse fourier transform of Transfer function to reconstruct filter
%
% created by Srinivas Gorur-Shandilya at 2:40 , 28 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [K] = ff_tfestimate(x,y,filter_length,f_tau)
global K

[T,W] = tfestimate(x,y,[],[],filter_length);
W = W/max(W);

[~,f_cut]=min(real(T(1:floor(length(T)/3))));
f_cut = W(f_cut);
if isnan(f_tau)
	f_tau = f_cut/3;
end

% roll off contributions of higher frequencies
S = exp(-abs(W-f_cut)./f_tau);
S(W<f_cut) = 1;
T = T.*S;

K = (real(ifft(T)));
K = interp1(1:length(K),K,0.5:0.5:length(K));


