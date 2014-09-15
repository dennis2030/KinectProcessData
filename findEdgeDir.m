function edgeDir = findEdgeDir(im)

[BW,thresh,gv,gh] = edge(im(:,:,1),'sobel');

% find edge normals
edgeDir = atan2(gv, gh);

% normalize -pi~pi to 0~1
edgeDir = edgeDir + pi;
filter = edgeDir < 0;
edgeDir(filter) = 0;
edgeDir = edgeDir ./ (pi*2);
filter = edgeDir > 1;
edgeDir(filter) = 1;

end
