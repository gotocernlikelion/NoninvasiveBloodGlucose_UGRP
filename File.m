classdef File

    properties
        Property1
    end

    methods(Static)

        function Measure()
            clc;
            clear;

            % Create a new file
            cd(".\Data\") % 파일 접근
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

            % Load the background array
            if isfile("background_array.mat") % search the background array
                load("background_array.mat"); % load background array
            else
                background_array = zeros(128,128); % make a zero array instead of background array
            end
            
            % Input the parameters
            B.Exposure_time = '2000'; % input('Exposure time: ', 's');
            B.FPS = '60'; % input('Frames per second: ', 's');
            B.Measurement_time = '1.5'; % input('Measurement time: ', 's');
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
            g = gigecam(string(gc.IPAddress(1)), 'PixelFormat', 'Mono12');
        
            g.AcquisitionFrameRateAbs = B.FPS;
            g.AcquisitionFrameRateEnable = 'True';
            g.Width = 128;      g.Height = 128;
            g.OffsetY = 437;    g.OffsetX = 537;    g.GainRaw = 3;
            g.ExposureTimeAbs = B.Exposure_time;
        
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
            pixel_location = [  14    95    26    84    67    41    57; % x coord
                                47    20    87    24    96    16    56; % y coord
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
                test_img = snapshot(g);
                % maxVal = max([maxVal max(test_img(:))]);
        
                subplot(3,1,1:2)
                colormap("jet");
                imagesc(test_img,[0 2500]);
                axis image
                colorbar();
                title('ROI check - Make sure each ROI box is well within each beam')
                col_img = [];
                for i = 1:7
                    y1 = pixel_location(2,i);
                    y2 = pixel_location(2,i) + 20;
                    x1 = pixel_location(1,i);
                    x2 = pixel_location(1,i) + 20;
                    lw = 0.5;
                    if ch_log(i) > 0; lw = 2; end
                    line([x1 x2],[y1,y1],'color',ch_text(i),'linewidth',lw);
                    line([x1 x2],[y2,y2],'color',ch_text(i),'linewidth',lw);
                    line([x1 x1],[y1,y2],'color',ch_text(i),'linewidth',lw);
                    line([x2 x2],[y1,y2],'color',ch_text(i),'linewidth',lw);
                    col_img = [col_img int_img test_img(y1:y2,x1:x2)];        
                end
        
                subplot(3,1,3)
                imagesc(col_img, [0 2500])
                colormap('jet')
                xticks(xtickarray);
                xticklabels(ch_text4xlabel)
                yticklabels({})
                axis image
                title("press SPACEBAR to proceed, or Q to quit")
        
                pause(0.1)
                if h0.CurrentCharacter == 'Q'
                    disp('Quitting the program ...')
                    
                    close(h0)
                    return;
                    break;
                elseif h0.CurrentCharacter == ' '
                     title([datestr(now) ' ROI calibration image'])
                     saveas(gcf,[CurDir '/' DataDir filename_BFI '_calib.png'])
                     saveas(gcf,[CurDir '/' DataDir filename_BFI '_calib'])
                    break;
                end
            end
            % main loop
        
            tic
        
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
            tic
            for j = 1:totalframe
                test_img = snapshot(g);
                while 1      % wait until img is read from the camera
                    if ~isempty(test_img)
                        break
                    else
                        continue
                    end
                end
                img = cast(test_img,'double'); % change data type because img of initial condiditon is uint16
                img2 = img - background_array; % - let's bypass bg subtraction for now
        
                for i = 1:ch_len    % BFI calculation for selected channels
                    
                    hold on
        
                    y1 = pixel_location(2,ch_num(i));
                    y2 = pixel_location(2,ch_num(i)) + 20;
                    x1 = pixel_location(1,ch_num(i));
                    x2 = pixel_location(1,ch_num(i)) + 20;
                    img_array{i}(:,:,j) = img(y1:y2,x1:x2); % raw data
                    samp_img2 = img2(y1:y2,x1:x2); % background subtrated data
                                
                    sum_intensity = sum(img_array{i}(:,:,j),'all');
                    %PPG_box = -log(sum_intensity);
                    PPG_box = sum_intensity;
        
                    temp = im2col(samp_img2,[7 7],'distinct');
                    MEAN = mean(temp);
                    STD = std(temp,1);
                    K = STD./MEAN;
                    BFI_box = (1./K.^2)'; % 9x1 column vector 
                    % didn't work when 1/K'.^2 was used (figure out later)
            
                    BFI_box_mean = mean(BFI_box);
                    BFI_box_std = std(BFI_box);
        
            
                    final_BFI(i,j) = BFI_box_mean;
                    final_BFI_std(i,j)= BFI_box_std;
                    final_PPG(i,j) = PPG_box;
            
                    if rem(j,600) == 0       % plotting BFI every 10s
                        figure(h2)
                        maxPlot = max([maxPlot BFI_box_mean+BFI_box_std]);
                        errorbar(j/B.FPS/60,BFI_box_mean,BFI_box_std,'-s', ...
                            'color',B.Channel(i),'MarkerSize',5,'MarkerFaceColor','k');
                        axis([0 B.Measurement_time 0 maxPlot*1.2])
                    end
                end
            
            end
            toc
            
            total_time = toc;
            eachtime = toc/totalframe;
            framerate = 1/eachtime;
            % saving our precious data neatly
            meanBFI = final_BFI';
            stdBFI = final_BFI_std';
            meanPPG = final_PPG';
        
         
            save([CurDir '/' DataDir filename_BFI],'meanBFI');
            save([CurDir '/' DataDir filename_PPG],'meanPPG');
            save([CurDir '/' DataDir filename_img],'img_array');
            
            figure(h2)
            saveas(gcf,[CurDir '/' DataDir filename_BFI '_test-MC-DSCA-fulltime-graph.png'])
            saveas(gcf,[CurDir '/' DataDir filename_PPG '_test-MC-DSCA-fulltime-graph.png'])
            % close(h2);
        
            T = table(meanBFI, stdBFI);
            writetable(T, [CurDir '/' DataDir filename_BFI '.csv'])
            writetable(T, [CurDir '/' DataDir filename_PPG '.csv'])
            % plot the whole data, after FIR filtering
            %     meanBFIarray = round(mean(meanBFI));
            %     stdBFIarray = round(std(meanBFI));
            %     
            %     meanPPGarray = round(mean(meanPPG));
            %     stdPPGarray = round(std(meanPPG));
        
            windowsize = 5;
            b = 1/windowsize*ones(1,windowsize);
            filtBFI = filter(b,1,meanBFI);
            filtPPG = filter(b, 1, meanPPG);
            h4 = figure;
            set(h4,'position',[1 200 800 300],'ToolBar','none','MenuBar','none');
               
            j = 1:size(meanBFI,1);
            for q = 1:ch_len
                hold on
                plot(j/(B.FPS*60),filtBFI(:,q),B.Channel(q))
            %         str_str = strcat(num2str(meanBFIarray(q)),' ± ' ,num2str(stdBFIarray(q)));
            %         text((totalframe/(B.FPS*60)) * 1.04, max(max(filtBFI))*(0.7-0.1*(q-1)), str_str, "Color",B.Channel(q), "FontSize",10);
                
            end
            xline(xpos)
            xlabel('time (min)')
            ylabel('BFI')
            %     B.ChanDesc = {'LD1','LD2','RD1','RD2'};
            %     legend({B.ChanDesc{:}},'Location','northeastoutside')
            %     legend box off
            title(['Postprocessed data averaged over ' num2str(windowsize) ' datapoints'])
            saveas(gcf,[CurDir '/' DataDir filename_BFI '_test-MC-DSCA-graph.png']);
        
            h5 = figure;
            set(h5,'position',[1 200 800 300],'ToolBar','none','MenuBar','none');
            j = 1:size(meanPPG,1);
            for q = 1:ch_len
                hold on
                plot(j/(B.FPS*60),meanPPG(:,q),B.Channel(q))
            %         str_str = strcat(num2str(meanBFIarray(q)),' ± ' ,num2str(stdBFIarray(q)));
            %         text((totalframe/(B.FPS*60)) * 1.04, max(max(filtBFI))*(0.7-0.1*(q-1)), str_str, "Color",B.Channel(q), "FontSize",10);
                
            end
            xline(xpos)
            xlabel('time (min)')
            ylabel('PPG')
            %     B.ChanDesc = {'LD1','LD2','RD1','RD2'};
            %     legend({B.ChanDesc{:}},'Location','northeastoutside')
            %     legend box off
            title(['Postprocessed data averaged over ' num2str(windowsize) ' datapoints'])
            saveas(gcf,[CurDir '/' DataDir filename_PPG '_test-MC-DSCA-graph.png']);
        
            % close(h4);
           
            User_note = inputdlg(prompt,dlgtitle,dim);
            % disp(User_note{:})
            % if isempty(User_note{:})
            %     disp('User note empty')
            %     return
            % end
        
            % making Readme.txt
            meanBFIarray = round(mean(meanBFI));
            stdBFIarray = round(std(meanBFI));
        
            fid = fopen([CurDir '\' DataDir '\readme.txt'],'w');
            
            fprintf(fid, [DataDir filename_BFI]);
            fprintf(fid, [DataDir filename_PPG]);
            fprintf(fid, '\n%s', datestr(now));
            fprintf(fid, '\n\n==Camera Parameters==\n');
            fprintf(fid,'Acq Frame Rate = %.1d Hz\n',g.AcquisitionFrameRateAbs);
            fprintf(fid,'GainRaw = %.1d \n', g.GainRaw);
            fprintf(fid,'Exposure Time = %.1f ms\n', g.ExposureTimeRaw/1000);
            fprintf(fid, '\n==Protocol Info==\n');
            fprintf(fid, 'Channel = %s \n', B.Channel);
            %     for j = 1:ch_len
            %         fprintf(fid, '%s = %s \n', B.Channel(j),B.ChanDesc{j});
            %     end
            for j = 1:ch_len
                fprintf(fid, 'mean %s = %d \n', B.Channel(j),meanBFIarray(j));
            end
            for j = 1:ch_len
                fprintf(fid, 'std %s = %d \n', B.Channel(j),stdBFIarray(j));
            end
            fprintf(fid, 'Measurment time = %d min\n', B.Measurement_time);
            fprintf(fid, 'starting stimulus time = %.1f min\n', B.str_point);
            fprintf(fid, 'duration time = %.1f min\n', B.duration);
            fprintf(fid, '\n==User Note==\n');
            
            fprintf(fid, '%s\n', User_note{1}');
            
            fclose(fid);
            close(h5)
            close(h4)
            close(h2)
            close(h0) 

            cd ..
        end
    
        function PlotGraph()
            %파일 찾기 및 접근
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
                elseif contains(string(mat_file(i).name) , "PPGdata") 
                    Extract(2).data_name = mat_file(i).name;
                    Extract(2).data_file= mat_file(i).folder;
                end
            
            end
            
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
            % [B.Mean_BFI, B.Std_BFI] = Mean_Std(B.filtBFI);
            
            % clear legend
            % legend({B.color_value(:)}, 'Location','northeastoutside');
        end
       
    end
end