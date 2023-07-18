clear,clc;

% raw_data 
x1 = linspace(0,10,500);
raw_data = sin(x1) + 0.5*sin(10*x1)+0.8*rand(1,length(x1));

% initialization
data_buffer=[0,0,0,0,0];
T_amp=[0.0,1.0];
grad=0; % gradient of five point : input point and its four previous points
current_grad=0; % gradient of five point : five previous points before a point
amp=0;
i=1;
prev_peak=0;
prev_trough=0;
filtered = [];

% noise ppg generation 관련 parameters
num_iteration = 0;
max_iteration = 500;

% tolerance list 
tol = [ 0.95, 0.9, 1.2,1.2];

% peak trough swing
peak_found = true;
trough_found = true;

% finding peak and trough
while num_iteration < max_iteration
%     fprintf("num_iteration:%d \n, ",num_iteration)
    x=data_buffer(i);
    grad=least_sq(data_buffer);
    num_iteration = num_iteration+1;
%     fprintf("grad : %f, current_grad: %f\n", grad, current_grad)
    if grad<0 && current_grad>=0 && trough_found % found peak
        amp=x-prev_trough;
        if T_amp(1) < amp && T_amp(2) > amp 
            T_amp = [(tol(1)*T_amp(1)+amp*tol(2))/2, (tol(3)*T_amp(2)+amp*tol(4))/2];
            peak_found = true;
            trough_found = false;
            current_grad = grad;
            prev_peak = x;
            fprintf("I found a peak! : x=%f , amp=%f\n",x,amp)
            filtered = [filtered, x];
        else
            T_amp=[0.5*T_amp(1), 1.5*T_amp(2)];
            fprintf("T_amp size is not good , %d\n", num_iteration)
        end

    elseif grad>0 && current_grad<=0 && peak_found% found trough
        amp=abs(x - prev_peak);
        if T_amp(1) < amp && T_amp(2) > amp 
            T_amp = [(tol(1)*T_amp(1)+amp*tol(2))/2, (tol(3)*T_amp(2)+amp*tol(4))/2];
            trough_found=true;
            peak_found =false;
            prev_trough = x;
            fprintf("I found a trough! : x=%f , amp=%f\n",x,amp)
            filtered = [filtered, x];
        else
            T_amp=[0.5*T_amp(1), 1.5*T_amp(2)];
            fprintf("T_amp size is not good , %d \n", num_iteration)
        end
    end

    i=i+1;

    if i>=length(data_buffer)
        i=1;
    end

    data_buffer = ppg_with_noise(raw_data, data_buffer,num_iteration);
end

%plot filtered data and rawdata  
plot(filtered)
% hold on 
% plot(raw_data)

function data_buffer = ppg_with_noise(raw_data,data_buffer, num_iteration)
    for i = 1:4
        data_buffer(i) = data_buffer(i+1);
    end
    data_buffer(5) = raw_data(num_iteration);
end
