function segColor(inputPath)

im = imread(inputPath);

inputPath = strtrim(inputPath);
tmp_list = regexp(inputPath, '\/', 'split');
fname = tmp_list{numel(tmp_list)};
tmp_list2 = regexp(fname, '\.', 'split');
prefix = tmp_list2{1};
maskPath = tmp_list{1};

for i=2:numel(tmp_list)-2
    maskPath = [maskPath '/' tmp_list{i}];
end

maskPath = [maskPath '/color/' prefix '.jpeg']

mask = imread(maskPath);
size(mask)
size(im)

mask = imresize(mask,size(im));
imshow(mask);
end
