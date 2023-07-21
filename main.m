function main()
    try

        %데이터 탐색 & 경로추가
        MyData=dir('*-*-*'); 
            
        if isempty(MyData) 
            fprintf("no files \n");
            pause
        else
            for i=1:length(MyData)
                addpath(MyData(i).name);
            end
        end
        
        if exist("function\")
            addpath("function\");
        end
    
        while true
    
            %메모리 삭제
            clear,clc;
    
            %메뉴 선택
            fprintf("1. BFI/PPG Meausre \n");
            fprintf("2. BFI/PPG Plot \n");
            fprintf("3. exit \n");
            a=input('원하는 기능을 선택해 주세요:','s');
           
            if a == '1'
                File.Measure();
            elseif a == '2'
                File.PlotGraph();
            elseif a == '3'
                break
            else
                fprintf("입력오류 \n");
                pause
                break
            end
        
        end
    
        %메모리 삭제
        clear, clc;
    catch
        fprintf("unexpected errer \n");
    end
end