function visSkeDepth(joint1, joint2, rawDepth, plotPos)
    
    joint1X = joint1(1)-10;
    joint1Y = joint1(2);

    joint2X = joint2(1)-10;
    joint2Y = joint2(2);

    joint1D = rawDepth( joint1Y, joint1X );
    joint2D = rawDepth( joint2Y, joint2X );
    numP = round( norm([joint1X - joint2X , joint1Y - joint2Y]) ) 
    

    % list initialization
    skeList = zeros(3,numP);
    countourList = zeros(3,numP);

    for i=1:numP+1
        tmpX = round( joint1X * (numP-i+1) / numP + joint2X * (i-1) / numP );
        tmpY = round( joint1Y * (numP-i+1) / numP + joint2Y * (i-1) / numP );
        tmpZ = rawDepth(tmpY,tmpX) + rawDepth(tmpY-1,tmpX-1) + rawDepth(tmpY-1,tmpX) + rawDepth(tmpY-1,tmpX+1) + rawDepth(tmpY, tmpX-1) + rawDepth(tmpY,tmpX+1) + rawDepth(tmpY+1,tmpX-1) +rawDepth(tmpY+1,tmpX) + rawDepth(tmpY+1,tmpX+1);
        tmpZ = round( tmpZ / 9 );
        skeList(1,i) = tmpX;
        skeList(2,i) = tmpY;
        skeList(3,i) = tmpZ;

        while(1)
            tmpZ = rawDepth(tmpY,tmpX);
            if(tmpZ == 0)
                break;
            end
            tmpX = tmpX - 1;
        end
        countourList(1,i) = tmpX;
        countourList(2,i) = tmpY;
        countourList(3,i) = rawDepth(tmpY,tmpX+1);
    end
    
    slopes = zeros(numP);
    smoothSlopes = zeros(numP);

    % calc the slope between 2 points
    for i=1:numP
        slopes(i) = skeList(3,i+1) - skeList(3,i) ;
    end
    % smooth (????)
    for i=2:numP
        smoothSlopes(i) = slopes(i) + 1/2*slopes(i-1) + 1/2*slopes(i+1) ;
    end

    % set up vector and rotation matrix
    startJoint = [joint1X, joint1Y, joint1D];
    endJoint = [joint2X, joint2Y, joint2D];
    v = startJoint - endJoint;
    v2 = countourList(:,1) - countourList(:,numP+1);

    r = vrrotvec(v, [1,0,0]);
    m = vrrotvec2mat(r);
    
    r2 = vrrotvec(v2, [1,0,0]);
    m2 = vrrotvec2mat(r2);

    rotatedSkeleton = m * skeList;
    countourList = m2 * countourList;
    
    % indicate the sample locations
    for i=1:numP+1
        rawDepth(skeList(2,i) , skeList(1,i)) = 0;
    end
    disp('===original===');
    size(slopes)
    slopes
    subplot(plotPos);
%    plot(rotatedSkeleton(3,:));
    disp('===var===');
    var(slopes(:))/( mean(slopes(:))^2 )
    
    slopeFilter = slopes <= 2;
    slopes(slopeFilter) = 0;
    plot(slopes(:));
    rawDepth = rawDepth./ max(max(rawDepth(:,:)));
    rawDepthMask = rawDepth > 0;
    mean( mean(rawDepth(rawDepthMask)) )
%    subplot(122);
%    colormap('hot');
%    imagesc(rawDepth);
%    colorbar;

end

