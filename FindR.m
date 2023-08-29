%function FindR()
    
    clear
    clc

    FirstFolder=pwd;
    cd('./Data/')
    [file, path]=uigetfile('*.mat'); 
    addpath(path)
    load(file)
    
    fs=60;

    if contains(file,'BFIdata.mat') 
        hgt=size(meanBFI,2);
        for i=1:hgt
            raw_data(:,i)=meanBFI(:,i);                      
            raw_data(:,i)=smoothdata(raw_data(:,i),'movmean',5);
            fu_raw(:,i)=fft(raw_data(:,i));
        end       
    end

    if contains(file,'PPGdata.mat')
        hgt=size(meanPPG,2);
        for i=1:hgt
            %raw_data(:,i)=exp(-meanPPG(:,i));
            raw_data(:,i)=meanPPG(:,i);
            raw_data(:,i)=smoothdata(raw_data(:,i),'movmean',5);
        end
    end
    
%%
    Fs = 60;            % Sampling frequency                    
    T = 1/Fs;             % Sampling period       
    L = 10800;             % Length of signal
    t = (0:L-1)*T;        % Time vector

    Y = fft(raw_data(:,2));
    Y(1)=0;
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    f = Fs*(0:(L/2))/L;
    plot(f,P1) 

    cd(FirstFolder)
%%  

    t_sample=1; % 샘플 구간(초)
    num=60*t_sample; % 샘플 프레임 개수 
    % row=18;
    % col=10;
  
    L=length(raw_data); % 전체 프레임 개수
    num_sample=(L/num); % 샘플의 개수
    
    ter=num_sample/num;
    Time=1/60:1/60:num_sample;
    figure
    plot(Time,raw_data)

    title('rawdata')
    xlabel('time(t)')
    ylabel('amplitude')

 %% 
 
    for j=1:hgt
        %figure
        for i=1:num_sample
            
            %find max min average

            % subplot(row,col,i)
            % plot(raw_data(num*(i-1)+1:num*i,j))

            Max=max(raw_data(num*(i-1)+1:num*i,j));
            Min=min(raw_data(num*(i-1)+1:num*i,j));
            mu(i) = mean(raw_data(num*(i-1)+1:num*i,j));
                
            amp(i,j)=Max-Min;
            AC(i,j)=amp(i);
            DC(i,j)=mu(i);
            factor(i,j)=AC(i,j)/DC(i,j);
        end
    end
%%
    figure
    for i=1:num_sample
        R_factor(i)=factor(i,1)/factor(i,2);
    end
    plot(R_factor)
%end