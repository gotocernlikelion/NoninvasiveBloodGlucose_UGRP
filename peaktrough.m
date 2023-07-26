
clear;
clc;
origin=pwd;
[file,path]=uigetfile('*.mat');
cd(path)
load(file)
cd(pwd)


if contains(file,'BFIdata.mat') 
    raw_data=meanBFI(:);
%     filtraw_data=smoothdata(raw_data,'movmean',100);
%     raw_data=raw_data-filtraw_data;
    raw_data = exp(-1*raw_data);
    raw_data=smoothdata(raw_data,'sgolay',5);
else
    raw_data=meanPPG(:);
%     filtraw_data=smoothdata(raw_data,'movmean',100);
%     raw_data=raw_data-filtraw_data;
    raw_data = exp(-1*raw_data);
    raw_data=smoothdata(raw_data,'sgolay',5);
end

num=60;
row=num/6;
col=num/10;
L=length(raw_data);
t_max=L/60;
interval=(L/num);
i=1;

figure
while i<=num
    ter=t_max/num;
    t=ter*(i-1)+1/60:1/60:ter*i;
    subplot(row,col,i)

    %plot raw data
    plot(t,raw_data(interval*(i-1)+1:interval*i))

    %find max min
    Max=max(raw_data(interval*(i-1)+1:interval*i));
    Min=min(raw_data(interval*(i-1)+1:interval*i));
    
    hold on
    mu(i) = mean(raw_data(interval*(i-1)+1:interval*i));
    hline = refline([0 mu(i)]);
    hline.Color = 'r';
    hold on
    hline = refline([0 Max]);
    hline.Color = 'b';
    hold on
    hline = refline([0 Min]);
    hline.Color = 'b';

    title('rawdata')
    xlabel('t(s)')
    ylabel('amplitude')
    
    amp(i)=Max-Min;
    AC(i)=amp(i);
    DC(i)=mu(i);
    R_factor(i)=AC(i)/DC(i);
    i=i+1;
end


figure
plot(R_factor)
hold on
plot(AC)
hold on
plot(DC)
title('R factor')
xlabel('number of interval(num)')
ylabel('amplitude')
mean_R=mean(R_factor);

