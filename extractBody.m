function [cropped_head, cropped_torso, cropped_leftArm, cropped_rightArm] = extractBody(inputPath)
    depthWidth = 512;
    depthHeight = 424;
   
    % read the depth and joint infor from txt file
    [rawDepth, jointMap] = readDepth(inputPath);
    
    % use mask to filter out non-human pixels
    rawDepth = maskFilter(rawDepth, inputPath);

    % get depth image of human
    im = getDepthImage(rawDepth);

    % get joint infor
    shoulderLeft = jointMap('ShoulderLeft');
    shoulderRight = jointMap('ShoulderRight');    
    hipRight = jointMap('HipRight');
    hipLeft = jointMap('HipLeft');
    neck = jointMap('Neck');
    head = jointMap('Head');
    elbowLeft = jointMap('ElbowLeft');
    elbowRight = jointMap('ElbowRight');

    %%% for torso
    torso_rect = [shoulderLeft(1), neck(2), shoulderRight(1) - shoulderLeft(1), hipLeft(2) - neck(2)];
    cropped_torso = imcrop(im, torso_rect);
    %imshow(cropped_torso);
    
    %%% for head
    head_rect = [(shoulderLeft(1)+head(1) )/2 , head(2) - ( neck(2)-head(2) )/2, (shoulderRight(1)-shoulderLeft(1))/2, (neck(2)-head(2))*1.5];
    cropped_head = imcrop(im, head_rect);
%    imshow(cropped_head);

    %%% for left arms
%    imshow(im);
%    hold on;
%    plot([shoulderLeft(1),elbowLeft(1)], [shoulderLeft(2),elbowLeft(2)],'Color','r','LineWidth',3);
%    plot(shoulderLeft(1), shoulderLeft(2),'b.', 'MarkerSize',20);

    angle = calcAngle(shoulderLeft, elbowLeft);
    rotated_im = imrotate(im, angle,'crop');
    sz = size(im)/2+.5;

    cropped_leftArm = rotateAndCrop(rotated_im, shoulderLeft, elbowLeft, angle, sz, 'L');
%    imshow(cropped_leftArm);
    
    %%% for right arms
    %imshow(im);
%    hold on;
%    plot([shoulderRight(1), elbowRight(1)],  [shoulderRight(2), elbowRight(2)], 'Color', 'r', 'LineWidth', 3);
%    plot(shoulderRight(1), shoulderRight(2), 'b.', 'MarkerSize', 20);
    
    angle = calcAngle(shoulderRight, elbowRight);
    rotated_im = imrotate(im, angle, 'crop');
    sz = size(im)/2+.5;

    cropped_rightArm = rotateAndCrop(rotated_im, shoulderRight, elbowRight, angle, sz, 'R');
%    imshow(cropped_rightArm);

    

end
