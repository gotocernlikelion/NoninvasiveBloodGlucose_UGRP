classdef BloodAnalyze
    
    properties
        real_bfi = zeros(3600,4);
        mean_bfi = zeros(4,1);
        std_bfi = zeros(4,1);
        os_bfi = zeros(3600,4);
    end

    methods
        %constructor method
        function obj = BloodAnalyze(Rbfi, Mean, Std, Os)           
            obj.real_bfi = Rbfi;
            obj.mean_bfi = Mean;
            obj.std_bfi = Std;
            obj.os_bfi = Os;
        end 
    end

    methods
        function FT = FFT(obj) 
            %fft
            Fs = 60;            % Sampling frequency                    
            T = 1/Fs;             % Sampling period       
            L = 3600;             % Length of signal
            % t = (0:L-1)*T;        % Time vector

            %figure
            for i =1:4
                y = fft(obj.os_bfi(:,i));
                P2 = abs(y/L);
                P1 = P2(1:L/2+1);
                P1(2:end-1) = 2*P1(2:end-1);
                f = Fs*(0:(L/2))/L;
                
                %filter
                ft=smoothdata(P1,"sgolay",50);
                plot(f,ft)
                title("HeartRate")
                xlabel("f (Hz)")
                ylabel("|P1(f)|")
                legend();
                hold on 
                
            end
             
            return 
        end

        function BF = BFI(obj)
            figure
            for i=1:4
                x = obj.real_bfi(:,i); 
                plot(x, '-', 'linewidth', 2)
                xlabel("frame")
                ylabel("BFI")
                hold on 
            end
        end
    end
end