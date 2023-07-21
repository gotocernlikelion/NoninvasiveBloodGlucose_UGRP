function filtBFI = plotgraph_size(B, size)
    b = 1/size*ones(1, size);
    filtBFI = filter(b, 1, B.BFI_data);

    hold("on");

    for i = 1:length(B.color_value) - 1
        plot(B.x, filtBFI(:,i), B.color_value(i));
    end

    if B.str_point ~= 0
        xline([B.str_point B.str_point + B.duration]);
    end
        xlim([0 B.x(end)]);
end