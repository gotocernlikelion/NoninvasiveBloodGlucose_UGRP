%%
clear,clc,close;
%%
imaqreset
%%
gc = gigecamlist;
% gc.IPAddress(1)
%%
g1 = gigecam(string(gc.IPAddress(1)), 'PixelFormat', 'Mono12');
%%
g2 = gigecam(string(gc.IPAddress(2)), 'PixelFormat', 'Mono12');
%%
g1.AcquisitionFrameRateAbs = 60;
g1.AcquisitionFrameRateEnable = 'True';
g1.GainRaw = 3;
g1.ExposureTimeAbs = 2000;
g1.Timeout = 50;
g1.Width = 128;      g1.Height = 128;
g1.OffsetY = 437;    g1.OffsetX = 537;    g1.GainRaw = 3;
g1.ExposureTimeAbs = 2000;
%%
g2.AcquisitionFrameRateAbs = 60;
g2.AcquisitionFrameRateEnable = 'True';
g2.GainRaw = 3;
g2.ExposureTimeAbs = 2000;
g2.Timeout = 50;
g2.Width = 128;      g2.Height = 128;
g2.OffsetY = 437;    g2.OffsetX = 537;    g2.GainRaw = 3;
g2.ExposureTimeAbs = 2000;
%%
test_img1 = snapshot(g1);
colormap("jet");
imagesc(test_img1);
axis image
colorbar();
%%
tic
for i = 1:3600
    
    test_img1 = snapshot(g1);
    test_img2 = snapshot(g2);
     
    % maxVal = max([maxVal max(test_img(:))]);
    % subplot(2,1,1)
    % colormap("jet");
    % imagesc(test_img1);
    % axis image
    % colorbar();
    % 
    % subplot(2,1,2)
    colormap("jet");
    imagesc(test_img2);
    axis image
    colorbar();
    % pause(0.5)
    
end
toc