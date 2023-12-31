clear, clc

[file1, path1]=uigetfile('*.mat');
[file2, path2]=uigetfile('*.mat');
[R_factor1, mean_R1]=FindR(file1,path1);
[R_factor2, mean_R2]=FindR(file2,path2);


figure
plot(R_factor1)
hold on
plot(R_factor2)
title('AC/DC factor')
xlabel('number of interval(num)')
ylabel('amplitude')
legend
time=length(R_factor1);

figure
for i=1:time
    temp(i)=R_factor1(i)/R_factor2(i);
end
temp=smoothdata(temp,'sgolay',10);
plot(temp)
title('R factor')
xlabel('number of interval(num)')
ylabel('amplitude')

% per2=47;
% region(1) = mean(temp(1:40));
% window = 10;
% j=2;
% for i=per2:time
%     region(j)=mean(temp(i));
%     interval=per2;
%     if (i-interval)>window
%         j=j+1;
%         interval=i;
%     end
% end
% figure
% bar(region)
% A=mean_R1/mean_R2;

