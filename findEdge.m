function small_edge = findEdge(im)

small = imresize(im, [128,128]);
small_edge = edge(small(:,:,1),'canny');
small_edge = imresize(small_edge, [256,256]);

end
