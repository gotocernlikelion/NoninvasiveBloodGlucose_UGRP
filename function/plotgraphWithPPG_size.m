function [filtBFI,filtPPG] = plotgraphWithPPG_size(B,size_bfi,size_ppg)
    b_bfi = 1/size_bfi*ones(1, size_bfi);
    b_ppg = 1/size_ppg*ones(1, size_ppg);
    
    filtBFI = filter(b_bfi, 1, B.BFI_data);
    filtPPG = filter(b_ppg, 1, B.PPG_data);

    %eliminate DC noise
    filtBFI(1:size_bfi,:) = ones(size_bfi,1)*mean(filtBFI(size_bfi:end, :));
    filtPPG(1:size_ppg,:) = ones(size_ppg,1)*mean(filtPPG(size_ppg:end, :));

%     % normalize, offset 조정
%     filtBFI = filtBFI - mean(filtBFI);
%     %filtBFI = filtBFI/max(max(filtBFI));
%     filtPPG = filtPPG - mean(filtPPG);
%     %filtPPG = filtPPG/max(max(filtPPG));
%     %filtBFI = filtBFI - filter(100,1,filtBFI);
%     filtBFI = filtBFI/max(max(filtBFI));
%     %filtPPG = filtPPG - filter(100,1,filtPPG);
%     filtPPG = filtPPG/max(max(filtPPG));
    
    


    hold("on");

    
    %for i = 1:length(B.color_value) - 1
    for i=1
        yyaxis left
        plot(B.x, filtBFI(:,i), B.color_value(i));
        hold on
        yyaxis right
        plot(B.x_ppg, filtPPG(:,i),'k');
    end

    %legend({'g_{bfi}','c_{bfi}', 'g_{ppg}','c_{ppg}'},'Location','southwest')

    if B.str_point ~= 0
        xline([B.str_point B.str_point + B.duration]);
    end
    xlim([0 B.x(end)]);
    
end
