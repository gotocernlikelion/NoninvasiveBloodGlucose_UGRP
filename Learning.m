function Learning(BFI_data,PPG_data, DataDir)
    
    cd(".\Learning\")
    CurDir2=pwd;
    mkdir(CurDir2,DataDir) % 새 폴더 생성
    addpath(DataDir)
    filename_BFI = strcat('\',DataDir,'-BFIdata');
    filename_PPG = strcat('\',DataDir,'-PPGdata');
    writetable(BFI_data, [CurDir2 '/' DataDir filename_BFI '.csv'])
    writetable(PPG_data, [CurDir2 '/' DataDir filename_PPG '.csv'])
    prompt = {'Enter a value of \glucose (mg/dL)'};
    dlgtitle = 'Glucose concentration';
    dims = [1 40];
    definput = {'0'};
    opts.Interpreter = 'tex';
    answer = inputdlg(prompt,dlgtitle,dims,definput,opts);
    filename_glucose = strcat('\',DataDir,'-glucose');
    answer=cell2table(answer);
    writetable(answer, [CurDir2 '/' DataDir filename_glucose '.csv'])
    cd ..

end