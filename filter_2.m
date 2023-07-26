blms = dsp.BlockLMSFilter(10,5);
blms.StepSize = 0.01;
blms.WeightsOutputPort = false;
Filt = dsp.FIRFilter;
Filt.Numerator = fir1(10,[.5, .75]);
x = randn(1000,1); % Noise
d = Filt(x) + sin(0:.05:49.95)'; % Noise + Signal
[y, err] = blms(x, d);
subplot(2,1,1);
plot(d);
title('Noise + Signal');
subplot(2,1,2);
plot(err);
title('Signal');
