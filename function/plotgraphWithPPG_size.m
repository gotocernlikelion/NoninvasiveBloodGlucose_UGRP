function [filtBFI,filtPPG] = plotgraphWithPPG_size(B,size_bfi,size_ppg)

        
    filtBFI=smoothdata(B.BFI_data,'movmean',size_bfi);
    filtPPG=smoothdata(B.PPG_data,'movmean',size_ppg);
    B.color_value_ppg='mykw';
%     % normalize, offset 조정
%     filtBFI = filtBFI - mean(filtBFI);
%     %filtBFI = filtBFI/max(max(filtBFI));
%     filtPPG = filtPPG - mean(filtPPG);
%     %filtPPG = filtPPG/max(max(filtPPG));
%     %filtBFI = filtBFI - filter(100,1,filtBFI);
%     filtBFI = filtBFI/max(max(filtBFI));
%     %filtPPG = filtPPG - filter(100,1,filtPPG);
%     filtPPG = filtPPG/max(max(filtPPG));
    hgt=size(B.BFI_data,2);    
    %for i = 1:length(B.color_value) - 1
    for i=1:hgt
        yyaxis left
        plot(B.x, filtBFI(:,i), B.color_value(i),'LineStyle','-');
        hold on
        yyaxis right
        plot(B.x_ppg, filtPPG(:,i),B.color_value_ppg(i),'LineStyle','-');
    end

    %legend({'g_{bfi}','c_{bfi}', 'g_{ppg}','c_{ppg}'},'Location','southwest')

    if B.str_point ~= 0
        xline([B.str_point B.str_point + B.duration]);
    end
    xlim([0 B.x(end)]);
    
end
