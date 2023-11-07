function Learning(T,CurDir, DataDir)
    
    cd(".\Learning\")
    mkdir(CurDir, DataDir) % 새 폴더 생성
    addpath(DataDir)
    filename_BFI = strcat('\',DataDir,'-BFIdata');
    filename_PPG = strcat('\',DataDir,'-PPGdata');
    writetable(T, [CurDir '/' DataDir filename_BFI '.csv'])
    writetable(T, [CurDir '/' DataDir filename_PPG '.csv'])
    cd ..

end