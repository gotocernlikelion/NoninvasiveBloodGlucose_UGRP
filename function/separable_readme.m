function setting = separable_readme(B)
    setting = [];
    l_tot = length(B.readme_lines);
    lr = 0;

    for i = 1:l_tot
        line_i = convertStringsToChars(B.readme_lines(i));
        
        lr = regexp(B.readme_lines(i), ' = ');

        if lr ~= 0
            setting = [[string(line_i(1:lr-1)) string(line_i(lr+3:length(line_i)))]; setting];
        end
    end
end
