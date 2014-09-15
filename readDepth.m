
function [rawDepth, jointMap] = readDepth(inputPath)
    
    fid = fopen(inputPath);
    % first line, contains width and height
     
    width = 512;
    height = 424;
    
    % second line, contains joint locations
    jointMap = containers.Map;
        
    line = fgetl(fid);
    
    %%%
    % parse and put every joint's pos to a map
    %%%

    % split each body 
    line = strtrim(line);
    tmp_list = regexp(line, ';','split');
    for i=1:numel(tmp_list)
        tmpS = tmp_list{i};
        if strcmp(tmpS, '')
            continue;
        end
        tmpS = strtrim(tmpS);
        % split each joint
        tmp_list2 = regexp(tmpS, ',', 'split');
        for j=1:numel(tmp_list2)
            tmpS2 = tmp_list2{j};
            if strcmp(tmpS2, '')
                continue;
            end
            tmpS2 = strtrim(tmpS2);
            tmp_list3 = regexp(tmpS2, ':', 'split');
            jointType = tmp_list3{1};
            pos = tmp_list3{2};
            pos_list = regexp(pos, ' ', 'split');
            tmpX = str2num(pos_list{1});
            tmpY = str2num(pos_list{2});
            if(~isnumeric(tmpX))
                tmpX = 1;                
            end
            if(~isnumeric(tmpY))
                tmpY = 1;
            end

            jointMap(jointType) = [tmpX, tmpY];
        end
    end

    fclose(fid);
    rawDepth = dlmread(inputPath,' ',2,1);

    %%% post-processing, map depth to each joint
    keySet = keys(jointMap);
    for i=1:numel(keySet)
        tmp_joint = jointMap(keySet{i});
        if( numel(tmp_joint) == 0)
            tmp_joint(1) = 1;
            tmp_joint(2) = 1;
        end
        % out-of-bound handling
        if(tmp_joint(1) > width)
            tmp_joint(1) = width;
        end
        if(tmp_joint(1) < 1)
            tmp_joint(1) = 1;
        end
        if(tmp_joint(2) > height)
            tmp_joint(2) = height;
        end
        if(tmp_joint(2) < 1)
            tmp_joint(2) = 1;
        end

        tmpD = rawDepth(int32(round(tmp_joint(2))), int32(round(tmp_joint(1))));
        tmp_joint = [tmp_joint, tmpD];
        jointMap(keySet{i}) = tmp_joint;
    end
end
