function rawDepth = maskFilter(rawDepth,inputPath)

    tmp_list = regexp(inputPath, '\/', 'split');
    fname = tmp_list{numel(tmp_list)}
    tmp_list2 = regexp(fname, '\.', 'split');
    f_prefix = tmp_list2{1}
    
    maskPath = tmp_list{1};
    for i=2:numel(tmp_list)-1
        maskPath = [maskPath '/' tmp_list{i}];
    end

    maskPath = [maskPath '/' f_prefix '_mask.jpg']

    im = imread(maskPath);
    %imshow(im);
   % waitforbuttonpress();
    [height, width, channel] = size(im);
    for y=1:height
        for x=1:width
            if(im(y,x,1) > 200  && im(y,x,2) >200 && im(y,x,3) >200 )
                rawDepth(y,x) = 0;
            end
        end
    end
end
