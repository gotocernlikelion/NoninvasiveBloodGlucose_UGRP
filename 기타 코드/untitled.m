%% get camera list

clear,clc
gc = gigecamlist;
hgt=height(gc);
%% init camera

% for i = 1:hgt
%     g(i) = gigecam(string(gc.IPAddress(i)), 'PixelFormat', 'Mono12');
%     g(i).AcquisitionFrameRateAbs = 60;
%     g(i).AcquisitionFrameRateEnable = 'True';
%     g(i).GainRaw = 3;
%     g(i).ExposureTimeAbs = 2000;
%     g(i).Timeout = 50;
%     g(i).Width = 128;      g(i).Height = 128;
%     g(i).OffsetY = 437;    g(i).OffsetX = 537;    g(i).GainRaw = 3;
%     g(i).ExposureTimeAbs = 2000;
% end

g = gigecam(string(gc.IPAddress(1)), 'PixelFormat', 'Mono12');
g.AcquisitionFrameRateAbs = 60;
g.AcquisitionFrameRateEnable = 'True';
g.GainRaw = 3;
g.ExposureTimeAbs = 2000;
g.Timeout = 50;
g.Width = 128;      g.Height = 128;
g.OffsetY = 437;    g.OffsetX = 537;    g.GainRaw = 3;
g.ExposureTimeAbs = 2000;
%% snapshot img

commands(g)
executeCommand(g, 'DeviceRegistersStreamingStart');
