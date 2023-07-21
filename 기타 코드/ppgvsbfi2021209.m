%%
clear, clc, close all
%%
norimage = load("09-Dec-2022-norimage\09-Dec-2022-norimage-image.mat");
speckle_image = load("09-Dec-2022- bfi-jyp-60hz-3min-120\09-Dec-2022- bfi-jyp-60hz-3min-120-image.mat");
%%
length_speckle_cell = length(speckle_image.img_array);
length_speckle_array = length(speckle_image.img_array{1});
nor_ccd_image = zeros(21,21,length_speckle_array,length_speckle_cell);
bfi_array = zeros(length_speckle_cell,length_speckle_array);
bfi_array_std = zeros(length_speckle_cell,length_speckle_array);
ppg_array = zeros(length_speckle_cell,length_speckle_array);
ppg_array_std = zeros(length_speckle_cell,length_speckle_array);
%%
for i = 1:length_speckle_cell
    for j = 1:length_speckle_array
        nor_ccd_image(:,:,j,i) = speckle_image.img_array{i}(:,:,j)./norimage.nor_image(:,:,i);
    end
     
end
%%
for label = 1:length_speckle_cell
    for frame_value = 1:length_speckle_array
    
        samp_img = nor_ccd_image(:,:,frame_value,label);
        nor_samp_img = samp_img./norimage.nor_image(:,:,label);
        sum_intensity = sum(nor_samp_img,'all');
        mul = -log(sum_intensity); 

        B = im2col(samp_img,[7 7],'distinct');
        MEAN = mean(B);
        STD = std(B,1);
        K = STD./MEAN;
        BFI_box = (1./K.^2)'; % 9x1 column vector 
        % didn't work when 1/K'.^2 was used (figure out later)

        BFI_box_mean = mean(BFI_box);
        BFI_box_std = std(BFI_box);

        bfi_array(label,frame_value) = BFI_box_mean;
        bfi_array_std(label,frame_value)= BFI_box_std;
        ppg_array(label,frame_value) = mul;
    end
end
%%
windowsize = 5;
b = 1/windowsize*ones(1,windowsize);
filtBFI = filter(b,1,bfi_array);
filtppg = filter(b,1,ppg_array);
%%
hold on
yyaxis left
plot(filtBFI(1,121:360),'color','#0072BD')
ylabel("BFI (A.U)","FontSize",30,"FontWeight",'bold')
yyaxis right
plot(filtppg(1,121:360),'color','#D95319')
ylabel("PPG","FontSize",30,"FontWeight",'bold')
xticks([0 60 120 180 240])
xticklabels({'2','3','4','5','6'})
axis padded
xlabel("time (s)","FontSize",30,'FontWeight','bold')
title("BFI and PPG vs time","FontSize",30,"FontWeight","bold")
