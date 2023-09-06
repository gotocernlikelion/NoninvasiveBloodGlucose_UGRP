
clear
clc

FirstFolder=pwd;
cd('./Data/')
[file, path]=uigetfile('*.mat'); 
addpath(path)
load(file)

if contains(file,'BFIdata.mat') 
    hgt=size(meanBFI,2);
    for i=1:hgt
        raw_data(:,i)=meanBFI(:,i);                      
    end       
end

if contains(file,'PPGdata.mat')
    hgt=size(meanPPG,2);
    for i=1:hgt
        raw_data(:,i)=meanPPG(:,i);       
    end
end

fs=60;

% Below 2Hz 
d1 = designfilt("bandpassiir", ...
"SampleRate", 60, ...
"FilterOrder", 4, ...
"HalfPowerFrequency1", 1.1, ...
"HalfPowerFrequency2", 1.8);

t_sample=60; % 샘플 구간(초)
num=60*t_sample; % 샘플 프레임 개수 

L=length(raw_data); % 전체 프레임 개수
num_sample=(L/num); % 샘플의 개수

ter=num_sample/num;
Time= 1/fs:1/fs:num_sample;

% %%
%     Fs = 60;            % Sampling frequency                    
%     T = 1/Fs;             % Sampling period       
%     L = 1500;             % Length of signal
%     t = (0:L-1)*T;        % Time vector
%     Y = fft(raw_data(:,i));
%     P2 = abs(Y/L);
%     P1 = P2(1:L/2+1);
%     P1(2:end-1) = 2*P1(2:end-1);
%     f = Fs*(0:(L/2))/L;
%     plot(f,P1) 
%     title("Single-Sided Amplitude Spectrum of X(t)")
%     xlabel("f (Hz)")
%     ylabel("|P1(f)|")
% %%

for i=1:hgt
    for j=1:num_sample

       Time_sample= (num*(j-1)+1)/fs:1/fs:(num*j)/fs  ;
       % filter
       Y(i,j).sample=raw_data(num*(j-1)+1:num*j,i);
       
       Y(i,j).sample=detrend(Y(i,j).sample);
       Y(i,j).sample = lowpass(Y(i,j).sample,5,100);
        
       % moving average filter
       %Y(i,j).sample = Y(i,j).sample - smoothdata(Y(i,j).sample,'movmean',10);    
       %subplot(hgt, num_sample,(i-1)*num_sample+j)
       
       subplot(2, num_sample/2,j)
       plot(Time_sample,Y(i,j).sample)
       findpeaks(Y(i,j).sample,Time_sample,'MinPeakDistance',0.5)
       title('filtered data')
       xlabel('time(t)')
       ylabel('amplitude')
    end
    figure
end



cd(FirstFolder)






 