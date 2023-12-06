function raw_data=getPPG()
%% get BFI/PPG data
    clear, close, clc
    
    currentFolder = pwd;
    cd(".\Data\")
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