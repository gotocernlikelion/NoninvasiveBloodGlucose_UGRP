
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
"HalfPowerFrequency1", 2.5, ...
"HalfPowerFrequency2", 3.5);

t_sample=60; % 샘플 구간(초)
num=60*t_sample; % 샘플 프레임 개수 

L=length(raw_data); % 전체 프레임 개수
num_sample=(L/num); % 샘플의 개수

ter=num_sample/num;
Time= 1/60:1/60:num_sample;

for i=1:hgt
    for j=1:num_sample
       % bandpass filter
       Y(i,j).sample=raw_data(num*(j-1)+1:num*j,i);
       Y(i,j).sample = filtfilt(d1,Y(i,j).sample);
        
       % moving average filter
       Y(i,j).sample = Y(i,j).sample - smoothdata(Y(i,j).sample,'movmean',100);
       subplot(hgt, num_sample,(i-1)*num_sample+j)
       plot(Y(i,j).sample)
    end
end

cd(FirstFolder)






 