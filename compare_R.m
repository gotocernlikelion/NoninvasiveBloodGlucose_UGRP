clear, clc

[file1, path1]=uigetfile('*.mat');

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



