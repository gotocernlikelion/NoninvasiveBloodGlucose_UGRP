clear,clc;
data_buffer=[0,0,0,0,0];
T_amp=[0,1];

grad=0;
current_grad=0; 
amp=0;
i=0;
prev_peak=0;
prev_trough=0;
while 1
    x=data_buffer(i);
    grad=gradient(data_buffer);
    if grad<0 && current_grad>0
        amp=x-prev_trough;
        if T_amp(0) < amp && T_amp(1) > amp 
            T_amp = [(0.95*T_amp(0)+amp*0.60)/2, (1.2*T_amp(1)+amp*1.2)/2];
            peak_found = True;
            current_grad = grad;
        else
            T_amp=[0.5*T_amp(0), 1.5*T_amp(1)];
        end
    elseif grad>0 && current_grad<0
        amp=x-prev_peak;
        if T_amp(0) < amp && T_amp(1) > amp 
            T_amp=[(0.95*T_amp(0)+amp*0.60)/2, (1.2*T_amp(1)+amp*1.2)/2];
            trough_found=True;
        else
            T_amp=[0.5*T_amp(0), 1.5*T_amp(1)];
        end
    end
    i=i+1;
    if i>=length(data_buffer)
        i=0;
    end
end

