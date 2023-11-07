function modify_gige_plot()    
    %파일 찾기 및 접근
    cd(".\Data\")
    currentFolder = pwd;
    MyData=uigetdir();
    cd(MyData)
    mat_file=dir ('*.mat');
    cd(currentFolder)
    
    if isempty(mat_file)
        return
    end
    Extract=struct();
    
    for i = 1:length(mat_file)
        if contains(string(mat_file(i).name) , "BFIdata") 
            Extract(1).data_name = mat_file(i).name;
            Extract(1).data_file = mat_file(i).folder;  
        end

        if contains(string(mat_file(i).name) , "PPGdata") 
            Extract(2).data_name = mat_file(i).name;
            Extract(2).data_file= mat_file(i).folder;
        end    
    end
%%    
    %bfi
    B.data_name = string(Extract(1).data_name);
    B.BFI_data = importdata(B.data_name);
    
    B.readme_name = strcat(Extract(1).data_file, "\readme.txt");
    B.readme_lines = readlines(B.readme_name);
    
    B.setting_value = separable_readme(B);
                
    [B.color_value, B.color_label, B.Exposure_Time, B.GainRaw, B.FPS, B.str_point, B.duration] = readme_function(B);
    
    %ppg
    B.data_name_ppg = string(Extract(2).data_name);
    B.PPG_data = importdata(B.data_name_ppg);
    
    B.readme_name_ppg = strcat(Extract(2).data_file, "\readme.txt");
    B.readme_lines_ppg = readlines(B.readme_name_ppg);
    
    B.setting_value_ppg = separable_readme(B);
    
    [B.color_value_ppg, B.color_label_ppg, B.Exposure_Time_ppg, B.GainRaw_ppg, B.FPS_ppg, B.str_point_ppg, B.duration_ppg] = readme_function(B);
    
    %bfi
    B.x = (1:length(B.BFI_data))/(60 * B.FPS);
    B.min = B.x(length(B.BFI_data));
    B.size = input("Window Size(BFI): ");
    %ppg
    B.x_ppg = (1:length(B.PPG_data))/(60 * B.FPS);
    B.min_ppg = B.x(length(B.PPG_data));
    B.size_ppg = input("Window Size(PPG): ");
    
    % Graph plot 
    title(string(B.readme_lines(1)));
    xlabel("Time (min)", 'Fontsize', 10);
    ylabel("BFI/PPG (A.U.)", 'Fontsize', 10);
    
    % mean & std BFI
    %clear legend
    [B.filtBFI, B.filtPPG] = plotgraphWithPPG_size(B, B.size, B.size_ppg);
    %figure
    %[B.filtPPG] = plotgraph_size(B, B.size_ppg);
    % [B.Mean_BFI, B.Std_BFI] = Mean_Std(B.filtBFI);
    
    % clear legend
    % legend({B.color_value(:)}, 'Location','northeastoutside');
    
    clear
    clc
    cd ..
end