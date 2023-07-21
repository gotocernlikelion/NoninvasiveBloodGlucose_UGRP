function [Mean, Std] = Mean_Std(data)
    Mean = round(mean(data));
    Std = round(std(data));
end