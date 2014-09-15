function angle = calcAngle(point1, point2)

    v = [point2(1)-point1(1), point2(2) - point1(2)];
    cosAngle = dot(v, [0,1]) / ( norm(v) * norm([0,1]) );
    angle = acosd(cosAngle);
    cross_value = cross([v,0],[0,1,0]);
    if( cross_value(3) > 0)
        angle = -angle;
    end
end
