%%
clc,clear,close
%% load data
BFI_array = load("13-Jan-2023-sw-acupoint-2-13min\13-Jan-2023-sw-acupoint-2-13min-BFIdata.mat");
image_array = load("13-Jan-2023-sw-acupoint-2-13min\13-Jan-2023-sw-acupoint-2-13min-image.mat");
%%

heartbeatsize = 10;
b_size10 = 1/heartbeatsize*ones(1,heartbeatsize);
filter_BFI = filter(b_size10,1,BFI_array.meanBFI);
bfi_min = zeros(1,4);
bfi_max = zeros(1,4);

for w = 1:4
    bfi_min(1,w) = min(filter_BFI(10:end,w));
    bfi_max(1,w) = max(filter_BFI(10:end,w));
end

length_speckle_cell = length(image_array.img_array);
length_speckle_array = length(image_array.img_array{1});
ppg_array = zeros(length_speckle_cell,length_speckle_array);
ppg_array_std = zeros(length_speckle_cell,length_speckle_array);

%%
for label = 1:length_speckle_cell
    for frame_value = 1:length_speckle_array
    
        sum_intensity = sum(image_array.img_array{label}(:,:,frame_value),'all');
        mul = -log(sum_intensity); 
        ppg_array(label,frame_value) = mul;
    end
end

%%
new_ppg = detrend(ppg_array',20);
% new_ppg_2 = detrend(ppg_array',7);
% isequal(new_ppg,new_ppg_2)
%%
windowsize_ppg = 10;
b_ppg = 1/windowsize_ppg*ones(1,windowsize_ppg);
filtppg = filter(b_ppg,1,new_ppg);
%%
ppg_min = zeros(1,4);
ppg_max = zeros(1,4);

for w = 1:4
    ppg_min(1,w) = min(filtppg(10:end,w));
    ppg_max(1,w) = max(filtppg(10:end,w));
end
filter_BFI = [filter_BFI(:,1) filter_BFI(:,4) filter_BFI(:,2) filter_BFI(:,3)];
ppg_array = [filtppg(:,1) filtppg(:,4) filtppg(:,2) filtppg(:,3)]; 
bfi_min = [bfi_min(1,1) bfi_min(1,4) bfi_min(1,2) bfi_min(1,3)];
bfi_max = [bfi_max(1,1) bfi_max(1,4) bfi_max(1,2) bfi_max(1,3)];
ppg_min = [ppg_min(1,1) ppg_min(1,4) ppg_min(1,2) ppg_min(1,3)];
ppg_max = [ppg_max(1,1) ppg_max(1,4) ppg_max(1,2) ppg_max(1,3)];
xrange = (1:46800)/3600;
%% expect hh
titlelabel = ["LI1", "LI5","LI10","ST25"];
x_line = 296.5:20:(20*7+296.5);

for i = 1:4
    subplot(4,1,i)
    hold on
    yyaxis left
%     location = [x_line(1)/60 bfi_min(1,i)-5 ; x_line(1)/60 bfi_max(1,i)+5; x_line(2)/60 bfi_max(1,i)+5; x_line(2)/60 bfi_min(1,i)-5;
%                 x_line(3)/60 bfi_min(1,i)-5 ; x_line(3)/60 bfi_max(1,i)+5; x_line(4)/60 bfi_max(1,i)+5; x_line(4)/60 bfi_min(1,i)-5;
%                 x_line(5)/60 bfi_min(1,i)-5 ; x_line(5)/60 bfi_max(1,i)+5; x_line(6)/60 bfi_max(1,i)+5; x_line(6)/60 bfi_min(1,i)-5;
%                 x_line(7)/60 bfi_min(1,i)-5 ; x_line(7)/60 bfi_max(1,i)+5; x_line(8)/60 bfi_max(1,i)+5; x_line(8)/60 bfi_min(1,i)-5;];
    location = [x_line(1)/60 ppg_min(1,i)-5 ; x_line(1)/60 bfi_max(1,i)+5; x_line(2)/60 bfi_max(1,i)+5; x_line(2)/60 ppg_min(1,i)-5;
                x_line(3)/60 ppg_min(1,i)-5 ; x_line(3)/60 bfi_max(1,i)+5; x_line(4)/60 bfi_max(1,i)+5; x_line(4)/60 ppg_min(1,i)-5;
                x_line(5)/60 ppg_min(1,i)-5 ; x_line(5)/60 bfi_max(1,i)+5; x_line(6)/60 bfi_max(1,i)+5; x_line(6)/60 ppg_min(1,i)-5;
                x_line(7)/60 ppg_min(1,i)-5 ; x_line(7)/60 bfi_max(1,i)+5; x_line(8)/60 bfi_max(1,i)+5; x_line(8)/60 ppg_min(1,i)-5;];  
    ypos_1 = [1 2 3 4;
              5 6 7 8;
              9 10 11 12;
              13 14 15 16;];
    
    
    p = patch('Faces',ypos_1,'Vertices',location,'EdgeColor','none','FaceColor','#D3D3D3');
    ax= gca;
    ax.FontSize = 30;
    
    plot((10:length(filter_BFI(:,1)))/3600,filter_BFI(10:end,i),'color','#0072BD')
    axis([-1600/3660 48400/3600 ppg_min(1,i)-5 bfi_max(1,i)+5])
    ylabel({titlelabel(i),"BFI"},"FontSize",35,"FontWeight",'normal')
    yyaxis right
    plot((10:length(ppg_array(:,1)))/3600,ppg_array(10:end,i),'color','#D95319')
    ylabel({titlelabel(i),"BV"},"FontSize",35,"FontWeight",'normal')

    
%     axis padded
   
   
end

% ax.YAxis.FontSize = 15;
xlabel("time (min)","FontSize",45,'FontWeight','bold')
sgtitle("BFI vs BV 13min","FontSize",50,"FontWeight","bold")

%% for hh
% titlelabel = ["LI1", "LI10","ST25","LI5"];
% x_line = 296.5:20:(20*7+296.5);
% 
% for i = 1:4
%     subplot(4,1,i)
%     hold on
%     yyaxis left
% %     location = [x_line(1)/60 bfi_min(1,i)-5 ; x_line(1)/60 bfi_max(1,i)+5; x_line(2)/60 bfi_max(1,i)+5; x_line(2)/60 bfi_min(1,i)-5;
% %                 x_line(3)/60 bfi_min(1,i)-5 ; x_line(3)/60 bfi_max(1,i)+5; x_line(4)/60 bfi_max(1,i)+5; x_line(4)/60 bfi_min(1,i)-5;
% %                 x_line(5)/60 bfi_min(1,i)-5 ; x_line(5)/60 bfi_max(1,i)+5; x_line(6)/60 bfi_max(1,i)+5; x_line(6)/60 bfi_min(1,i)-5;
% %                 x_line(7)/60 bfi_min(1,i)-5 ; x_line(7)/60 bfi_max(1,i)+5; x_line(8)/60 bfi_max(1,i)+5; x_line(8)/60 bfi_min(1,i)-5;];
%     location = [296.5/60 ppg_min(1,i)-5 ; 296.5/60 bfi_max(1,i)+5; 336.5/60 bfi_max(1,i)+5; 336.5/60 ppg_min(1,i)-5;
%                 356.5/60 ppg_min(1,i)-5 ; 356.5/60 bfi_max(1,i)+5; 376.5/60 bfi_max(1,i)+5; 376.5/60 ppg_min(1,i)-5;
%                 396.5/60 ppg_min(1,i)-5 ; 396.5/60 bfi_max(1,i)+5; 416.5/60 bfi_max(1,i)+5; 416.5/60 ppg_min(1,i)-5;
%                 436.5/60 ppg_min(1,i)-5 ; 436.5/60 bfi_max(1,i)+5; 456.5/60 bfi_max(1,i)+5; 456.5/60 ppg_min(1,i)-5;];  
%     ypos_1 = [1 2 3 4;
%               5 6 7 8;
%               9 10 11 12;
%               13 14 15 16;];
%     
%     
%     p = patch('Faces',ypos_1,'Vertices',location,'EdgeColor','none','FaceColor','#D3D3D3');
%     ax= gca;
%     ax.FontSize = 15;
%     
%     plot((10:length(filter_BFI(:,1)))/3600,filter_BFI(10:end,i),'color','#0072BD')
%     axis([-1600/3660 48400/3600 ppg_min(1,i)-5 bfi_max(1,i)+5])
%     ylabel({titlelabel(i),"BFI"},"FontSize",25,"FontWeight",'normal')
%     yyaxis right
%     plot((10:length(filter_BFI(:,1)))/3600,filtppg(10:end,i),'color','#D95319')
%     ylabel({titlelabel(i),"PPG"},"FontSize",25,"FontWeight",'normal')
% 
%     
% %     axis padded
%    
%    
% end
% 
% % ax.YAxis.FontSize = 15;
% xlabel("time (min)","FontSize",20,'FontWeight','bold')
% sgtitle("S5 BFI vs detrnded HV 13min","FontSize",30,"FontWeight","bold")