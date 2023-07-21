%% thermal noise
clc,close,clear all;
%%
FPS = 60;
EXPOSURE = 2000;
gc = gigecamlist;
g = gigecam(string(gc.IPAddress), 'PixelFormat', 'Mono12');

g.AcquisitionFrameRateAbs = FPS;
g.AcquisitionFrameRateEnable = 'True';
g.Width = 128;      g.Height = 128;
g.OffsetY = 418;    g.OffsetX = 600;    g.GainRaw = 3;
g.ExposureTimeAbs = EXPOSURE;
%% make background
img_array = zeros(128:128:10);
img_array2 = zeros(128:128,"uint16");
for i = 1:10
    img = snapshot(g);
    
    img_array2 = img_array2 + img;
    
end
A = cast(img_array2,"double");
background_array = A/10;
imagesc(background_array)
colormap("jet")
colorbar;
%%
answer = questdlg('Do you want to save the backrgournd array?', ...
	'Save background');
% Handle response
switch answer
    case 'Yes'
        save("background_array","background_array");
    
    case 'No'
    
end
