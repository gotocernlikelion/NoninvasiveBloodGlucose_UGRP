%%
clear,clc,close;
%%
gc = gigecamlist;
% gc.IPAddress(1)
%%
g1 = gigecam(string(gc.IPAddress(1)), 'PixelFormat', 'Mono12');
g2 = gigecam(string(gc.IPAddress(2)), 'PixelFormat', 'Mono12');
%%
g1.AcquisitionFrameRateAbs = 60;
g1.AcquisitionFrameRateEnable = 'True';
g1.GainRaw = 3;
g1.ExposureTimeAbs = 2000;
%%
g2.AcquisitionFrameRateAbs = 60;
g2.AcquisitionFrameRateEnable = 'True';
g2.GainRaw = 3;
g2.ExposureTimeAbs = 2000;
%%
while true
    test_img1 = snapshot(g1);
    test_img2 = snapshot(g2);
    % maxVal = max([maxVal max(test_img(:))]);
    subplot(2,1,1)
    colormap("jet");
    imagesc(test_img1);
    axis image
    colorbar();

    subplot(2,1,2)
    colormap("jet");
    imagesc(test_img2);
    axis image
    colorbar();
    pause(0.5)
end