function [color_value, color_label, Exposure_Time, GainRaw, FPS, str_point, duration] = readme_function(B)
    color_value = {};
    color_label = '';
    Exposure_Time = 0;
    GainRaw = 0;
    FPS = 0;
    str_point = 0;
    duration = 0; 
    for i = 1:length(B.setting_value)
        
        if convertStringsToChars(B.setting_value(i, 1)) == "Channel"
            color_value = convertStringsToChars(B.setting_value(i, 2));
            color_label = color_value(1:length(color_value)-1);
                                                                          
        elseif convertStringsToChars(B.setting_value(i, 1)) == "Exposure Time"
            Exposure_Time = str2double(erase(B.setting_value(i, 2), 'ms'));   
                
        elseif convertStringsToChars(B.setting_value(i, 1)) == "GainRaw"
            GainRaw = str2double(B.setting_value(i, 2));
               
        elseif convertStringsToChars(B.setting_value(i, 1)) == "Acq Frame Rate"
            FPS = str2double(erase(B.setting_value(i, 2), 'Hz'));
        
        elseif convertStringsToChars(B.setting_value(i, 1)) == "starting stimulus time"
            str_point = str2double(erase(B.setting_value(i, 2), 'min'));
                 
        elseif convertStringsToChars(B.setting_value(i, 1)) == "duration time"
            duration = str2double(erase(B.setting_value(i, 2), 'min'));
        end
    end

end