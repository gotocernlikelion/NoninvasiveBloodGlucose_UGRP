function grad=least_sq(data_buffer)
    grad_mat = gradient(data_buffer);
    grad = grad_mat(end);
    %grad = mean(data_buffer);
end