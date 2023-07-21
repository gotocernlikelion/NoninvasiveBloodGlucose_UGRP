function myFun()
    persistent n
    if isempty(n)
        n=0;
    end
    n=n+1;
    fprintf("n의 값은?"+n+"\n");
end
