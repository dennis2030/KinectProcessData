function process(colorDir, depthDir, targetDir)

    % get the list of input directory
    inputFiles = dir([colorDir '/*.jpg']);

    % set size of all parts
    head_size = [256,256];
    torso_size = [256,256];
    leftArm_size = [256,256];
    rightArm_size = [256,256];

    % iterate through all images
    for i=1:numel(inputFiles)

        % get filename prefix from color image's name
        tmp_list = regexp(inputFiles(i).name, '/', 'split');
        fname = tmp_list{numel(tmp_list)};
        tmp_list2 = regexp(fname, '\.', 'split');
        prefix = tmp_list2{1}
        
        depthPath = [depthDir '/' prefix '.txt']
        % get body parts
        [cropped_head, cropped_torso, cropped_leftArm, cropped_rightArm] = extractBody(depthPath);
        
        % ===========For head=============== %
        if(size(cropped_head, 1) < 5)
            continue;
        end
        if(size(cropped_head, 2) < 5)
            continue;
        end

        tmp_head = imresize(cropped_head, head_size);
        head(:,:,1) = tmp_head;
        head(:,:,2) = tmp_head;
        head(:,:,3) = tmp_head;
        imwrite(head,[targetDir '/head/' prefix '.jpg']);

        % ==========For torso================ %
        if(size(cropped_torso, 1) < 5)
            continue;
        end
        if(size(cropped_torso, 2) < 5)
            continue;
        end

        tmp_torso = imresize(cropped_torso, torso_size);
        torso(:,:,1) = tmp_torso;
        torso(:,:,2) = tmp_torso;
        torso(:,:,3) = tmp_torso;        
        imwrite(torso,[targetDir '/torso/' prefix '.jpg']);
        % =========For leftArm================= %
        if(size(cropped_leftArm, 1) < 5)
            continue;
        end
        if(size(cropped_leftArm, 2) < 5)
            continue;
        end

        tmp_leftArm = imresize(cropped_leftArm, leftArm_size);
        leftArm(:,:,1) = tmp_leftArm;
        leftArm(:,:,2) = tmp_leftArm;
        leftArm(:,:,3) = tmp_leftArm;
        imwrite(leftArm,[targetDir '/leftArm/' prefix '.jpg']);

        % ========For rightArm================== %
        if(size(cropped_rightArm,1) < 5)
            continue;
        end
        if(size(cropped_rightArm,2) < 5)
            continue;
        end
        tmp_rightArm = imresize(cropped_rightArm, rightArm_size);
        rightArm(:,:,1) = tmp_rightArm;
        rightArm(:,:,2) = tmp_rightArm;
        rightArm(:,:,3) = tmp_rightArm;
        imwrite(rightArm,[targetDir '/rightArm/' prefix '.jpg']);

        % ========================== %

    end
end
