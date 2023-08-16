function operate_trigger()
%%
    clc,clear,close
    imaqreset
%%
    % 필요한 툴박스를 확인하고 로드합니다.
    if ~license('test', 'Image_Toolbox') || ~license('test', 'Image_Acquisition_Toolbox')
        error('Image Processing Toolbox와 Image Acquisition Toolbox가 필요합니다.');
    end
    
    % 이미지 캡처 장치 객체를 생성합니다.
    vid1 = videoinput('gige',1,'Mono12'); % 첫 번째 카메라
    vid2 = videoinput('gige',2,'Mono12'); % 두 번째 카메라
%%

    % 캡처 설정을 구성합니다. 필요한 설정에 따라 변경할 수 있습니다.
    triggerconfig(vid1, 'immediate');
    triggerconfig(vid2, 'immediate');
    
    triggerinfo(vid1)
    triggerinfo(vid2)

    % 미리 캡처할 프레임 수를 설정합니다.
    numFrames = 600;
    
    % 프레임을 캡처합니다.
    
%%
  
    tic
      
    for i = 1:numFrames

        start(vid1);
        start(vid2);
        
        % 프레임을 캡처합니다.
        frame1 = getdata(vid1, 1,"uint8");
        frame2 = getdata(vid2, 1,"uint8");
    
        IMG1(i).img=frame1;
        IMG2(i).img=frame2;
        
        % 캡처한 프레임을 처리하거나 표시합니다.
        subplot(2,1,1)
        imshow(frame1);
        subplot(2,1,2)
        imshow(frame2);
        hold on
    end
    toc

    % 캡처된 후 작업을 정리합니다.
    stop(vid1);
    stop(vid2);
    
    delete(vid1);
    delete(vid2);
    clear vid1 vid2;
end