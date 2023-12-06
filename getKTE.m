function kai=getKTE()

   clear, clc
   %raw_data=getPPG();
 
   currentFolder = pwd;
   cd("C:\Users\user\UGRP\NoninvasiveBloodGlucose_UGRP\Data\14-Nov-2023-reference_rts_785_808_830\")
   mat_file='14-Nov-2023-reference_rts_785_808_830-PPGdata';

   load(mat_file)
   num=size(meanPPG,1);
   hgt=size(meanPPG,2);

    raw_data=zeros(num,hgt);
    for i=1:hgt
        raw_data(:,i)=meanPPG(:,i);       
    end

   cd(currentFolder)

   %num=size(raw_data,1);
   s_frame=zeros(300,num/150-1,3);
   for i=1:3
        for n=1:(num/150)-1
            s_frame(:,n,i)=raw_data(150*(n-1)+1:150*(n-1)+300,i);
        end
   end
    
        kai=cal_KTE(s_frame,num);
        plot(kai)

end

% function Kaiger=cal_KTE(s_frame,t,n,i)
%     Kaiger=s_frame(t,n,i)*s_frame(t,n,i)-s_frame(t+1,n,i)*s_frame(t-1,n,i);
% end

 
