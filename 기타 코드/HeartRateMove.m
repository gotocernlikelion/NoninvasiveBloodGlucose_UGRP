% x1 = linspace(0,10,500);
% raw_data = sin(x1) + 0.5*sin(10*x1)+0.8*rand(1,length(x1));
% plot(raw_data)

clear,clc;

file=uigetfile('*.mat');
load(file)
if contains(file,'BFIdata.mat') 
    raw_data=meanBFI(:,1);
else
    raw_data=meanPPG(:,1);
end

%mean_bfi=mean(raw_data);
filtered=smoothdata(raw_data,'movmean',100);
std_bfi=std(raw_data);
os_bfi=raw_data-filtered;
mean_os_bfi=mean(os_bfi);
std_os_bfi=std(os_bfi);
% subplot(2,2,1)
% plot(raw_data)
% subplot(2,2,2) 
% plot(filtered)
% subplot(2,2,3)
% plot(os_bfi)

% Fs = 1000;            % Sampling frequency                    
% T = 1/Fs;             % Sampling period       
% L = 3600;             % Length of signal
% t = (0:L-1)*T;        % Time vector

% [pk,locs] = findpeaks(os_bfi,'MinPeakDistance',10,'MinPeakHeight',mean_os_bfi+2*std_os_bfi);
% figure
% findpeaks(os_bfi,'SortStr','descend','MinPeakDistance',10,'MinPeakHeight',mean_os_bfi+2*std_os_bfi)
% meanCycle = mean(diff(locs));



Fs = 60;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 3600;             % Length of signal
t = (0:L-1)*T;        % Time vector

Y=fft(os_bfi);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
figure
subplot(2,1,1)
plot(f,P1) 
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")
mean_P1=mean(P1);
[psor,lsor] = findpeaks(P1,f,'SortStr','descend','MinPeakHeight',mean_P1,'MinPeakDistance',25);
subplot(2,1,2)
findpeaks(P1,f)
text(lsor+.02,psor,num2str((1:numel(psor))'))

% d = designfilt('lowpassfir', ...        % Response type
%        'FilterOrder',25, ...            % Filter order
%        'PassbandFrequency',1, ...     % Frequency constraints
%        'StopbandFrequency',3, ...
%        'DesignMethod','ls', ...         % Design method
%        'PassbandWeight',1, ...          % Design method options
%        'StopbandWeight',2, ...
%        'SampleRate',60);               % Sample rate

y=lowpass(os_bfi,5,Fs);

t=1/60:1/60:180;

figure
plot(t,y)


% figure
% findpeaks(P1,f,'Annotate','extents','WidthReference','halfheight')
