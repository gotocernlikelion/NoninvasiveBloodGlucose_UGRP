%function OperatingGige()
    
    clc;
    clear;

    % Create a new file
    cd(".\garbage\") % 파일 접근
    CurDir = pwd; % 현재 폴더 경로 저장
    CurDate = date; % 현재 날짜 저장
    
   
    disp(['The present working directory is ' CurDir])
    B.Filename = input('Type a new experiment name : ', 's');

    DataDir = [CurDate '-' B.Filename]; 
    disp(['Creating a new data directory : ' DataDir])

    mkdir(CurDir, DataDir) % 새 폴더 생성
    addpath(DataDir);
    prompt = {'실험 중 특이사항을 적어주세요.'};
    dlgtitle = '비고';
    dim = [4 50];
    cd .. % 원래 파일 이동

%%
    imaqreset
    
    % Load the background array
    if isfile("background_array.mat") % search the background array
        load("background_array.mat"); % load background array
    else
        background_array = zeros(128,128); % make a zero array instead of background array
    end
    
    % Input the parameters
    B.Exposure_time = '2000'; % input('Exposure time: ', 's');
    B.FPS = '60'; % input('Frames per second: ', 's');
    B.Measurement_time = '1'; % input('Measurement time: ', 's');
    B.str_point = '0'; % input('Start point: ', 's');
    B.duration = '0'; % input('Duration: ', 's');
    B.Channel = 'g'; % input('Channel: ', 's');
    
    ch_text = 'rgbcmyw';   % all the available channels ('bgorsyp' for old)
    
    B.Exposure_time = str2double(B.Exposure_time);
    B.FPS = str2double(B.FPS);
    B.Measurement_time = str2double(B.Measurement_time);
    
    if ~isempty(B.str_point) && ~isempty(B.duration)
        
        B.str_point = str2double(B.str_point);
        B.duration = str2double(B.duration);
    else
        B.str_point = 0;
        B.duration = 0;
    end
    
    ch_len = length(B.Channel);
    ch_num = zeros(1,ch_len);
    ch_log = false([1 7]);      % logical array of size 1x7
    for i = 1:ch_len
        ch_num(i) = strfind(ch_text, B.Channel(i));
        ch_log = ch_log + (ch_text == B.Channel(i));
    end
    disp(['Current setting is ' num2str(ch_len) ' channels (' B.Channel '), FPS of ' num2str(B.FPS) 'Hz'])
    % Set up the measurement time
    totalTime_in_sec = B.Measurement_time*60; % convert min to sec
    totalframe = totalTime_in_sec*B.FPS; %% convert sec to the number of frame
    
    % Set up variable for BFI calculation
    final_BFI = zeros(ch_len,totalframe,'double');
    final_BFI_std = zeros(ch_len,totalframe,'double');
    final_PPG = zeros(ch_len,totalframe,'double');
    
    for i = 1:ch_len
        img_array{i} = zeros(21,21,totalframe);
    end
    
    % Initializing GigE camera
    gc = gigecamlist;
    hgt=height(gc);
    for i = 1:hgt
        g(i) = gigecam(string(gc.IPAddress(i)), 'PixelFormat', 'Mono12');
    
        g(i).AcquisitionFrameRateAbs = B.FPS;
        g(i).AcquisitionFrameRateEnable = 'True';
        g(i).Width = 128;      g(i).Height = 128;
        g(i).OffsetY = 437;    g(i).OffsetX = 537;    g(i).GainRaw = 3;
        g(i).ExposureTimeAbs = B.Exposure_time;
    end
    
    ch_text4xlabel = {};    % has to be a cell variable for xtick labeling
    
    for i = 1:7
        xtickarray(i) = 14 + (i-1)*23;
        ch_text4xlabel{i} = ch_text(i);
    end
    
    % coordinates of upper left corner of each ROI
    %             %                   r     g     b     c     m     y     w
    %             pixel_location = [  14    98    26    84    67    41    57; % x coord
    %                                 47    66    87    24    96    16    56; % y coord
    %                              ];
    
    %                   r     g     b     c     m     y     w
    pixel_location = [  14    98    26    84    67    41    57; % x coord
                        47    37    87    24    96    16    56; % y coord
                     ];
    
    % checking speckle image
    h0 = figure;
    set(h0,'position',[50 50 500 550],'ToolBar','none','MenuBar','none');
    int_img = zeros(21,2);  % a narrow spacing between 21x21 images
    filename_BFI = strcat('\',DataDir,'-BFIdata');
    filename_PPG = strcat('\',DataDir,'-PPGdata');
    filename_img = strcat('\',DataDir,'-image');
    
    % maxVal = 0;
    while true
        for i = 1:hgt
            CH(i).test_img = snapshot(g(i));
            % maxVal = max([maxVal max(test_img(:))]);
            subplot(2,hgt,i)
            colormap("jet");
            imagesc(CH(i).test_img,[0 2500]);
            axis image
            colorbar();
            title('ROI check - Make sure each ROI box is well within each beam')
    
            col_img = [];
            for j = 1:7
                y1 = pixel_location(2,j);
                y2 = pixel_location(2,j) + 20;
                x1 = pixel_location(1,j);
                x2 = pixel_location(1,j) + 20;
                lw = 0.5;
                if ch_log(j) > 0; lw = 2; end
                line([x1 x2],[y1,y1],'color',ch_text(j),'linewidth',lw);
                line([x1 x2],[y2,y2],'color',ch_text(j),'linewidth',lw);
                line([x1 x1],[y1,y2],'color',ch_text(j),'linewidth',lw);
                line([x2 x2],[y1,y2],'color',ch_text(j),'linewidth',lw);
                col_img = [col_img int_img CH(i).test_img(y1:y2,x1:x2)];
                CH(i).col_img = col_img;
            end
    
            subplot(2,hgt,i+hgt)
            imagesc(CH(i).col_img, [0 2500])
            colormap('jet')
            xticks(xtickarray);
            xticklabels(ch_text4xlabel)
            yticklabels({})
            
    
            axis image
            title("press SPACEBAR to proceed, or Q to quit")
            pause(0.1)
        end
        
       
        if h0.CurrentCharacter == 'Q' 
            disp('Quitting the program ...')
            
            close(h0)
            return
            break
            
        elseif h0.CurrentCharacter == ' '
            title([datestr(now) ' ROI calibration image'])
            saveas(gcf,[CurDir '/' DataDir filename_BFI '_calib.png'])
            saveas(gcf,[CurDir '/' DataDir filename_BFI '_calib'])
            break
        end
    end
%%
    close
    tic
    for j = 1:totalframe
        for i = 1 : hgt
            CH(i).test_img = snapshot(g(i));
            while 1      % wait until img is read from the camera
                if ~isempty(CH(i).test_img)
                    break
                else
                    continue
                end
            end
            img = cast(CH(i).test_img,'double'); % change data type because img of initial condiditon is uint16
            IMG(:,:,i)=img;
            img2 = img - background_array; % - let's bypass bg subtraction for now
            IMG2(:,:,i)=img2;
        end
        
        
        for i = 1:ch_len    % BFI calculation for selected channels

            y1 = pixel_location(2,ch_num(i));
            y2 = pixel_location(2,ch_num(i)) + 20;
            x1 = pixel_location(1,ch_num(i));
            x2 = pixel_location(1,ch_num(i)) + 20;

            for k = 1 : hgt

                CH(k).img_array{i}(:,:,j) = IMG(y1:y2,x1:x2,k); % raw data
                CH(k).samp_img2 = IMG2(y1:y2,x1:x2,k); % background subtrated data
                sum_intensity = sum(CH(k).img_array{i}(:,:,j),'all');
                %PPG_box = -log(sum_intensity);
                PPG_box(i,j,k) = sum_intensity;

                temp = im2col(CH(k).samp_img2,[7 7],'distinct');
                MEAN = mean(temp);
                STD = std(temp,1);
                K = STD./MEAN;
                BFI_box = (1./K.^2)'; % 9x1 column vector 
                % didn't work when 1/K'.^2 was used (figure out later)
    
                BFI_box_mean(i,j,k) = mean(BFI_box);
                BFI_box_std(i,j,k) = std(BFI_box);
           
    
                final_BFI(i,j,k) = BFI_box_mean(i,j,k);
                final_BFI_std(i,j)= BFI_box_std(i,j,k);
                final_PPG(i,j,k) = PPG_box(i,j,k);
        
            end
        end
    end
    toc

    h2 = figure;    % figure window for BFI Graph plot
    set(h2,'position',[1 250 800 300],'ToolBar','none','MenuBar','none');
    
    % BFI
    figure(h2)

    xlabel("time (min)","FontSize",12)
    ylabel("BFI (AU)","FontSize",12)
    title([DataDir ' realtime BFI graph'],"FontSize",16)
    xpos = [B.str_point (B.str_point + B.duration)];
    xline(xpos)
    
    hold on

    maxPlot = 10;

    for j = 1:totalframe
        for i = 1 : ch_len
            for k = 1 : hgt
                if rem(j,600) == 0       % plotting BFI every 10s
                    figure(h2)
                    maxPlot = max([maxPlot BFI_box_mean(i,j,k)+BFI_box_std(i,j,k)]);
                    errorbar(j/B.FPS/60,BFI_box_mean(i,j,k),BFI_box_std(i,j,k),'-s', ...
                        'color',B.Channel(i),'MarkerSize',5,'MarkerFaceColor','k');
                    axis([0 B.Measurement_time 0 maxPlot*1.2])
                end
            end
        end           
    end

    
%end

%% delete folder
cd("garbage\")
rmdir("*-*-*-*","s")
cd ..