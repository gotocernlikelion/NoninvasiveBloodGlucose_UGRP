function findHRV()
%% get BFI/PPG data
    clear
    close
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
    
%% calculate HR
    
    filtered_data(:,:)=zeros(size(raw_data(:,:)));
    fs=60;
    L=length(raw_data);
    Time= 1/fs:1/fs:L/fs;
    
    for i=1:hgt
        figure

        % moving average filter
        raw_data(:,i)=detrend(raw_data(:,i));
        filtered_data(:,i)=lowpass(raw_data(:,i), 4, 100); 
        plot(Time,filtered_data(:,i))
        findpeaks(filtered_data(:,i),Time,'MinPeakDistance',0.5);
        [HR(i).peaks,HR(i).locs]=findpeaks(filtered_data(:,i),Time,'MinPeakDistance',0.5);
        title('filtered data')
        xlabel('time(t)')
        ylabel('amplitude')
    end
    
    for i=1:hgt

        HR(i).hrv=diff(HR(i).locs);
        for j=1:length(HR(i).hrv)
            HR(i).hrv(j)=1/(HR(i).hrv(j));
        end
        figure
        plot(HR(i).hrv)
            
    end
    
    cd(FirstFolder)
%%
end

