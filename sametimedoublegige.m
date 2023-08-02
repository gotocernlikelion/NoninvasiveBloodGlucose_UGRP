%%
clear,clc,close;
%%
imaqreset
%%
gc = gigecamlist;
hgt=height(gc);
%%
for i = 1:hgt
    g(i) = gigecam(string(gc.IPAddress(i)), 'PixelFormat', 'Mono12');
    g(i).AcquisitionFrameRateAbs = 60;
    g(i).AcquisitionFrameRateEnable = 'True';
    g(i).GainRaw = 3;
    g(i).ExposureTimeAbs = 2000;
    g(i).Timeout = 50;
    g(i).Width = 128;      g(i).Height = 128;
    g(i).OffsetY = 437;    g(i).OffsetX = 537;    g(i).GainRaw = 3;
    g(i).ExposureTimeAbs = 2000;
end
%%
for i = 1:10 
    tic
        test_img = snapshot(g(1));
    toc
    subplot(2,1,1)
    colormap("jet");
    imagesc(test_img);
    axis image
    colorbar();
end