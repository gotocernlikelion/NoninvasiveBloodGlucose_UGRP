function findNIRS()
%% get BFI/PPG data
    
    clear, close, clc
    
    currentFolder = pwd;
    cd("C:\Users\user\UGRP\NoninvasiveBloodGlucose_UGRP\Data\06-Nov-2023-RTS_808_785_830_glucose")
    mat_file='06-Nov-2023-RTS_808_785_830_glucose-PPGdata';

    load(mat_file)
    num=size(meanPPG,1);
    hgt=size(meanPPG,2);

    raw_data=zeros(num,hgt);
    for i=1:hgt
        raw_data(:,i)=meanPPG(:,i);       
    end

    cd(currentFolder)
    
 %% define parameter
    
    % units: cm
   
    wavelength=["660";"785";"808";"830"];
    mu_s_prime=[16.8;12.8;12.3;11.8];
    %              glucose         Hb   HbO2
    e=array2table([0.01515,3227.0,319.6;0.00856,977.04,735.4;0.00856,733.7,840.0;0.00725,693.0,974.0],"VariableNames",["glucose","Hb","HbO2"]);
    var_table=table(wavelength,mu_s_prime,e);
  
    row = 1;

    e_matrix = [var_table.e(4,"glucose"), var_table.e(4,"Hb"), var_table.e(4,"HbO2");  
                var_table.e(2,"glucose"), var_table.e(2,"Hb"), var_table.e(2,"HbO2"); 
                var_table.e(3,"glucose"), var_table.e(3,"Hb"), var_table.e(3,"HbO2")];
    
    e_matrix=table2array(e_matrix);

    mu_s_prime_matrix = [var_table.mu_s_prime(4);var_table.mu_s_prime(2);var_table.mu_s_prime(3)];
    
    real_glucose_rate=86;

    mu_a_matrix =[e_matrix(1,1)*real_glucose_rate*10^(-5);e_matrix(2,1)*real_glucose_rate*10^(-5);e_matrix(3,1)*real_glucose_rate*10^(-5)];

    
%% get I_0
    
    rho=1;
    temp=mu_a_matrix.*mu_s_prime_matrix';
    coe_term = ((rho^2)*sqrt(3)*temp)./(2*((rho)*sqrt(temp)+1));

    I=zeros(num,hgt);
    for i=1:3
        I(:,i)=exp(-raw_data(:,i));
    end
    I_0=I*exp(coe_term);
    
%% get concentration

    cd C:\Users\user\UGRP\NoninvasiveBloodGlucose_UGRP
    raw_data=getPPG();
    I=zeros(num,hgt);
    for i=1:3
        I(:,i)=exp(-raw_data(:,i));
    end

    C=log(I./I_0);
    cal_mu_s_prime_matrix=zeros(num,hgt);
    for i=1:hgt
        for j=1:num
            cal_mu_s_prime_matrix(j,i)=cal_mu_s_prime_matrix(j,i)+mu_s_prime_matrix(i);
        end
    end    
    mu_a_matrix=(rho*cal_mu_s_prime_matrix-2*C)+sqrt((rho^2)*cal_mu_s_prime_matrix.*cal_mu_s_prime_matrix-4*rho*C.*cal_mu_s_prime_matrix)./(2*C.*C);
    

    % get concentration
    concentration = e_matrix\mu_a_matrix';
    concentration = (concentration*10^(-5))';
    concentration=smoothdata(concentration,"movmean",60);
    t=0:1/60:60;

    plot(t(1:num),concentration)
    xlabel('time(s)')
    ylabel('concentration(mg/dl)')
    
    cd .\..
end

function raw_data=getPPG()
%% get BFI/PPG data
    clear, close, clc
    
    cd(".\Data\")
    currentFolder = pwd;
    MyData=uigetdir();
    cd(MyData)
    mat_file=dir ('*-PPGdata.mat');
    
    if isempty(mat_file)
        return
    end
    
    num = 3600;
    
    load(mat_file.name);
    hgt=size(meanPPG,2);
    raw_data=zeros(num,hgt);
    for i=1:hgt
        raw_data(:,i)=meanPPG(:,i);       
    end
    cd(currentFolder)
end