function main()

        %데이터 탐색 & 경로추가
        currentFolder=pwd; %현재 폴더 위치 파악
        addpath(".\*");
        cd(".\Data\") % data 폴더 접근
        MyData=dir('*-*-*'); %폴더 탐색
            
        if isempty(MyData) 
            fprintf("no files \n");
            pause(1);
        else
            for i=1:length(MyData)
                addpath(MyData(i).name);
            end
        end

        cd(currentFolder)
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
                modify_gige_operating();
            elseif a == '2'
                modify_gige_plot();  
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
end