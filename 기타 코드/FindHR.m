%function FindHR()
    
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
            raw_data(:,i)=smoothdata(raw_data(:,i),'movmean',25);
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
    
    t_sample=1; % 샘플 구간(초)
    num=60*t_sample; % 샘플 프레임 개수 
   
    L=length(raw_data); % 전체 프레임 개수
    num_sample=(L/num); % 샘플의 개수
    
    ter=num_sample/num;
    Time= 1/60:1/60:num_sample;
    
    for i=1:hgt
        y1(:,i) = filtfilt(d1,raw_data(:,i));
        y1(:,i)=y1(:,i)-smoothdata(y1(:,i),'movmean',100);
    end
    cd(FirstFolder)

    plot(Time,y1(:,1))

   
   % for i=1:hgt

        
        %subplot(hgt,hgt,i)
        % findpeaks(y1(:,i),Time,"MinPeakDistance",0.5,"MinPeakHeight",0);
        % [PEAKS(i).Peak,PEAKS(i).Locs]=findpeaks(y1(:,i),Time,"MinPeakDistance",0.5,"MinPeakHeight",0);
        % PEAKS(i).HR=diff(PEAKS(i).Locs);
        
        %title('rawdata')
        %xlabel('time(t)')
        %ylabel('amplitude')

        %subplot(hgt,hgt,i+hgt)
        %histogram(PEAKS(i).HR)
       
   % end
   
%end