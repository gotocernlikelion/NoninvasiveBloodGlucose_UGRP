file1=load("Data\04-Aug-2023-nobreath-660\04-Aug-2023-nobreath-660-PPGdata.mat");
file2=load("Data\04-Aug-2023-nobreath-808\04-Aug-2023-nobreath-808-PPGdata.mat");


raw_data1=-log(file1.meanPPG(:));
raw_data2=-log(file2.meanPPG(:));
raw_data1=smoothdata(raw_data1,'movmean',5);
raw_data2=smoothdata(raw_data2,'movmean',5);

t1=0:1/60:90;
t=t1(2:end);

figure
plot(t,raw_data1)
hold on
plot(t,raw_data2)

title('rawdata')
xlabel('t(s)')
ylabel('amplitude')