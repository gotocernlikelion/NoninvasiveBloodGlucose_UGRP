clc;
clear;
% Create a new file
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

%%
% Load the background array
if isfile("background_array.mat") % search the background array
    load("background_array.mat"); % load background array
else
    background_array = zeros(128,128); % make a zero array instead of background array
end
% Input the parameters
B.Exposure_time = '2000';% input('Exposure time: ', 's');
B.FPS = '60';%input('Frames per second: ', 's');
B.Measurement_time = '1';% input('Measurement time: ', 's');
B.str_point = '0';% input('Start point: ', 's');
B.duration = '0';% input('Duration: ', 's');
B.Channel = 'g';% input('Channel: ', 's');

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
g = gigecam(string(gc.IPAddress), 'PixelFormat', 'Mono12');

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
x=0;
% while true
%     if x == 0
%         test_img = snapshot(g);
%         image(test_img)
%         [x,y]=getpts;
%     else
%         break
%     end
% end
%%

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
    [x,y]=getpts;
    if ~isempty(x) 
        break
    end
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