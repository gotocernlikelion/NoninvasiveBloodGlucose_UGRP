
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

figure
for i=1:length(R_factor1)
    temp(i)=R_factor1(i)/R_factor2(i);    
end
plot(temp)
title('R factor')
xlabel('number of interval(num)')
ylabel('amplitude')
A=mean_R1/mean_R2;

