function cropped_img = rotateAndCrop(rotated_im, point1, point2, angle, sz, direction)

    % rotation matrix
    rotMat2D = [cosd(angle), -sind(angle); sind(angle), cosd(angle)];

    % shift the origin
    tmp_point1 = point1(1:2);
    tmp_point1(1) = tmp_point1(1)-sz(2);
    tmp_point1(2) = tmp_point1(2)-sz(1);
    tmp_point2 = point2(1:2);
    tmp_point2(1) = tmp_point2(1)-sz(2);
    tmp_point2(2) = tmp_point2(2)-sz(1);

    % rotate the joint point
    rotated_point1 = tmp_point1 * rotMat2D;
    rotated_point2 = tmp_point2 * rotMat2D;

    % shift back the origin
    rotated_point1(1) = rotated_point1(1)+sz(2);
    rotated_point1(2) = rotated_point1(2)+sz(1);
    rotated_point2(1) = rotated_point2(1)+sz(2);
    rotated_point2(2) = rotated_point2(2)+sz(1);

%    imshow(rotated_im);
%    hold on;
%    plot([rotated_point1(1), rotated_point2(1)],[rotated_point1(2), rotated_point2(2)],'Color','r','LineWidth',3);   
%    plot(rotated_point1(1), rotated_point1(2),'b.', 'MarkerSize',20);
%    waitforbuttonpress;

    % create arm rect base on direction
    length = abs(rotated_point1(2)-rotated_point2(2));
    if(direction == 'L')
        rect = [rotated_point1(1)-length/3, rotated_point1(2), length/3, length];
    elseif(direction == 'R')
        rect = [rotated_point1(1), rotated_point1(2), length/3, length];
    end

    cropped_img = imcrop(rotated_im, rect);

end
