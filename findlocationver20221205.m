%% clear
close all 
clear all 
clc 

%%
% tiff_info = imfinfo('jyp_arm.tif'); 
% background = imread("jypbackground_5.tif");
% baselinemeanspeckleimage = zeros(480,640,'double');
% tiff_stack = imread('jyp_arm.tif',1);
pixel_location = zeros(4,7);
roibox_y = zeros(5,7);
roibox_x = zeros(5,7);
sum_image = zeros(128,128,'double');

label_list = ['r', 'g', 'b', 'c', 'm', 'y','w'];
lname = ["red label", "green label", "blue label", "cyan label"...
       , "magenta label", "yellow label","white lable"];
center_point = zeros(2,7);
for i = 1:7

    name = strcat(label_list(i),'.tiff');
    label = imread(name);
    label = cast(label,'double');
%     label = label/16;
%     label = rot90(label,3);
    
    
    [y,x] = find(label > 100);
    new_y = sort(y);
    new_x = sort(x);
    new_y = unique(new_y);
    new_x = unique(new_x);
    mid_y = median(new_y, "all");
    mid_x = median(new_x, "all");

    mid_y = round(mid_y);
    mid_x = round(mid_x);
    center_point(:,i) = [mid_y; mid_x];
    down_y = mid_y - 10;
    up_y = mid_y +10;
    left_x = mid_x - 10;
    right_x = mid_x + 10;
%     disp(label_list(i),'center_y',mid_y, ...
%                        'center_x',mid_x, ...
%                        'down_y',down_y, ...
%                        'up_x',up_y, ...
%                        'left_x',left_x, ...
%                        'right_x',right_x)

    

    pixel_location(:,i) = [down_y up_y left_x right_x]

    roibox_y(:,i) = [down_y up_y up_y down_y,down_y];
    roibox_x(:,i) = [left_x left_x right_x right_x,left_x];
    
    figure();
    colormap("hot");
    hold on
    sum_image = sum_image + label;
    imagesc(label);
    plot(roibox_x(:,i),roibox_y(:,i),'b')
    axis([0 128 0 128])
    title(lname(i),'FontSize',18);
    colorbar;

   
end

 
 figure();
 colormap("hot");
 hold on
 imagesc(sum_image);
 plot(roibox_x,roibox_y,'b')
 axis([0 128 0 128])
 title("sum image",'FontSize',18);
 colorbar;
 sz = size(pixel_location)
