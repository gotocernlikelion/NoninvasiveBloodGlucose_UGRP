function findHR()
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
    
    a=input('sample time:','s');
    b=input('width:','s');
    a=str2double(a);
    b=str2double(b);


    fs=60;
    t_sample=a; % 샘플 구간(초)
    num=60*t_sample; % 샘플 프레임 개수 
    
    L=length(raw_data); % 전체 프레임 개수
    num_sample=(L/num); % 샘플의 개수
    
    ter=num_sample/num;
    Time= 1/fs:1/fs:num_sample;
    n=b;
    
    for i=1:hgt
        figure
        for j=1:num_sample
    
           Time_sample= (num*(j-1)+1)/fs:1/fs:(num*j)/fs;
           % filter
           Y(i,j).sample=raw_data(num*(j-1)+1:num*j,i);
           
           Y(i,j).sample=detrend(Y(i,j).sample);
            
           % moving average filter
           %Y(i,j).sample = Y(i,j).sample - smoothdata(Y(i,j).sample,'sgolay',10);
           Y(i,j).sample = lowpass(Y(i,j).sample,4,100);
           %Y(i,j).sample = highpass(Y(i,j).sample,0.4,100);
               
           %plot sample ppg data
           subplot(num_sample/n,n,j)
           plot(Time_sample,Y(i,j).sample)
           findpeaks(Y(i,j).sample,Time_sample,'MinPeakDistance',0.5)
           [HR(i,j).peaks,HR(i,j).locs]=findpeaks(Y(i,j).sample,Time_sample,'MinPeakDistance',0.5);
           title('filtered data')
           xlabel('time(t)')
           ylabel('amplitude')
           HR(i,j).heart_rate=length(HR(i,j).peaks);
           
        end
    
    end


    cd(FirstFolder)
end





 