% tests.m
% 
% created by Srinivas Gorur-Shandilya at 7:56 , 20 September 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

pHeader;


%% 
% This document runs tests for fitFilter2Data. Run the tests and generate a report (this document) using 
%
%  makePDF('tests.m')
% 

%%
% You can run these tests with the debug_mode set to "true" in the preferences file (pref.m) to see more of the inner working of this toolbox in each test. 

%% 1. White Noise Inputs, No Noise
% In this section, we test the simplest possible case: white noise inputs, no additional noise, with a bilobed filter. This test passes if the backed out filter (red) and the actual filter (black) match perfectly (shapewise). 

x = randn(1e4,1);
K = filter_alpha2(50,100,1,.3,1:500);
y = filter(K,1,x);
try
	[Khat,filtertime] = fitFilter2Data(x,y,'filter_length',500);
	disp('test 1 passed')

	figure('outerposition',[0 0 1000 500],'PaperUnits','points','PaperSize',[1000 500]); hold on
	subplot(1,2,1), hold on
	plot(K,'k')
	title('Actual filter')

	subplot(1,2,2), hold on
	plot(filtertime,Khat,'r')
	title('Reconstructed filter')

	prettyFig()


catch err
	disp('test 1 failed with error:')
	disp(err.message)
end

if being_published
	snapnow
	delete(gcf)
end

%% 2. Offset
% We now want to backout a filter allowing for some offset, as we want to mimic a case where there is an unknown lag in the signal we feed to the filter estimation routines. 

try
	[Khat,filtertime] = fitFilter2Data(x,y,'filter_length',600,'offset',100);
	disp('test 2 passed')

	figure('outerposition',[0 0 1000 500],'PaperUnits','points','PaperSize',[1000 500]); hold on
	subplot(1,2,1), hold on
	plot(-99:500,[zeros(1,100) K],'k')
	title('Actual filter')

	subplot(1,2,2), hold on
	plot(filtertime,Khat,'r')
	title('Reconstructed filter')

	prettyFig()

catch err
	disp('test 2 failed with error:')
	disp(err.message)
end

if being_published
	snapnow
	delete(gcf)
end


%% 3. Only Some Points
% We now want to back out the filter, using only data from only some time points. These time points can be arbitrarily picked from the data, and there is no requirement for continuity of any sort. The purpose of this test is to make sure that filter extraction works when we force it to work only with an arbitrary subset of the data. 

%%
% To prevent fitFilter2Data from using some points in time, simply set the response at those times to NaN. fitFilter2Data will ignore them. 


only_these_points = (rand(length(y),1)>.5);
y2 = y;
y2(~only_these_points) = NaN; 
try 
	[Khat,filtertime] = fitFilter2Data(x,y2,'filter_length',600,'offset',100);
	disp('test 3 passed')
catch
	disp('test 3 failed with message:')
	disp(err.message)
end

figure('outerposition',[0 0 1000 500],'PaperUnits','points','PaperSize',[1000 500]); hold on
subplot(1,2,1), hold on
plot(-99:500,[zeros(1,100) K],'k')
title('Actual filter')

subplot(1,2,2), hold on
plot(filtertime,Khat,'r')
title('Reconstructed filter')

prettyFig()

if being_published
	snapnow
	delete(gcf)
end

%% 4. Only Some Points, Offset, Additive Noise
% Now, we repeat the same test, but add some Gaussian noise to the output before backing out the filter. 

try
	noise = logspace(-2,1,5);
	c = parula(length(noise)+1);
	Khat = NaN(600,length(noise));
	L = {};
	for i = 1:length(noise)
		only_these_points = (rand(length(y),1)>.5);
		y2 = y + noise(i)*randn(length(y),1);
		y2(~only_these_points) = NaN; 
		[Khat(:,i),filtertime] = fitFilter2Data(x,y2,'filter_length',600,'offset',100);
		L{i} = ['log(noise)=' oval(log10(noise(i)))];
	end

	figure('outerposition',[0 0 1000 500],'PaperUnits','points','PaperSize',[1000 500]); hold on
	subplot(1,2,1), hold on
	plot(-99:500,[zeros(1,100) K],'k')
	title('Actual filter')

	subplot(1,2,2), hold on
	l = [];
	for i = 1:length(noise)
		l(i) = plot(filtertime,Khat(:,i),'Color',c(i,:));
	end
	legend(l,L)
	title('Reconstructed filter')

	prettyFig()
	disp('test 4 passed')
catch err
	disp('test 4 failed with error:')
	disp(err.message)
end

if being_published
	snapnow
	delete(gcf)
end

%% 5. Only Some Points, Offset, Additive Noise, Correlated Inputs
% Now, we repeat the tests as before, but introduce correlations into the input. 


try
	noise = -.5;
	corr_length = ceil(logspace(1,2,5));
	c = parula(length(corr_length)+1);
	Khat = NaN(600,length(corr_length));
	L = {};
	for i = 1:length(corr_length)
		x = filter(ones(corr_length(i),1),corr_length(i),randn(1e4,1));
		only_these_points = (rand(length(y),1)>.5);
		y2 = filter(K,1,x) + noise*randn(length(y),1);
		y2(~only_these_points) = NaN; 
		[Khat(:,i),filtertime] = fitFilter2Data(x,y2,'filter_length',600,'offset',100);
		L{i} = ['corr =' oval((corr_length(i)))];
	end

	figure('outerposition',[0 0 1000 500],'PaperUnits','points','PaperSize',[1000 500]); hold on
	subplot(1,2,1), hold on
	plot(-99:500,[zeros(1,100) K],'k')
	title('Actual filter')

	subplot(1,2,2), hold on
	l = [];
	for i = 1:length(corr_length)
		l(i) = plot(filtertime,Khat(:,i),'Color',c(i,:));
	end
	legend(l,L)
	title('Reconstructed filter')

	prettyFig()
	disp('test 5 passed')
catch err
	disp('test 5 failed with error:')
	disp(err.message)
end

if being_published
	snapnow
	delete(gcf)
end


%% 6. Only Some Points, Offset, Additive Noise, Correlated Inputs, fixed regularisation
% Now, we repeat the tests as before, with introduce correlations into the input, but force a fixed regularisation (here, equal to the mean of the eigenvalue of the covariance matrix of the input) 

try
	noise = -.5;
	corr_length = ceil(logspace(1,2,5));
	c = parula(length(corr_length)+1);
	Khat = NaN(600,length(corr_length));
	L = {};
	for i = 1:length(corr_length)
		x = filter(ones(corr_length(i),1),corr_length(i),randn(1e4,1));
		only_these_points = (rand(length(y),1)>.5);
		y2 = filter(K,1,x) + noise*randn(length(y),1);
		y2(~only_these_points) = NaN; 
		[Khat(:,i),filtertime] = fitFilter2Data(x,y2,'filter_length',600,'offset',100,'reg',1);
		L{i} = ['corr =' oval((corr_length(i)))];
	end

	figure('outerposition',[0 0 1000 500],'PaperUnits','points','PaperSize',[1000 500]); hold on
	subplot(1,2,1), hold on
	plot(-99:500,[zeros(1,100) K],'k')
	title('Actual filter')

	subplot(1,2,2), hold on
	l = [];
	for i = 1:length(corr_length)
		l(i) = plot(filtertime,Khat(:,i),'Color',c(i,:));
	end
	legend(l,L)
	title('Reconstructed filter')

	prettyFig()
	disp('test 6 passed')
catch err
	disp('test 6 failed with error:')
	disp(err.message)
end

if being_published
	snapnow
	delete(gcf)
end


%% Version Info
%
pFooter;


