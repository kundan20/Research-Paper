clc;    % Clear the command window.
workspace;  % Make sure the workspace panel is showing.
format longg;
format compact;
files = dir('F:\m\IMFDB_final\IMFDB_final')
files(1:2)=[];
 dirFlags = [files.isdir] ;
 subFolders = files(dirFlags);
 answer = zeros(1,145);
for j=1 : length(subFolders)  
% Get list of all subfolders.
    allSubFolders = genpath(subFolders(j).name);
% Parse into a cell array.
    remain = allSubFolders;
    listOfFolderNames = {};
    while true
        [singleSubFolder, remain] = strtok(remain, ';');
    
        if isempty(singleSubFolder)
            break;
        end
        listOfFolderNames = [listOfFolderNames singleSubFolder];
    end
    numberOfFolders = length(listOfFolderNames)
    % Process all image files in those folders.
    for k = 1 : numberOfFolders
        % Get this folder and print it out.
        thisFolder = listOfFolderNames{k};
        fprintf('Processing folder %s\n', thisFolder);
        % Get PNG files.
        filePattern = sprintf('%s/*.png', thisFolder);
        baseFileNames = dir(filePattern);
        % Add on TIF files.
        filePattern = sprintf('%s/*.tif', thisFolder);

        baseFileNames = [baseFileNames; dir(filePattern)];
        % Add on JPG files.
        filePattern = sprintf('%s/*.jpg', thisFolder);

        baseFileNames = [baseFileNames; dir(filePattern)];

        numberOfImageFiles = length(baseFileNames);
        %text files
        filePattern = sprintf('%s/*.txt', thisFolder);
        textfilenames = dir(filePattern);
        % Processing the text files here 
        if length(textfilenames)>=1
            textname = fullfile(thisFolder, textfilenames.name);
            fprintf('     Processing text file %s\n', textname);
            fid = fopen(textname);

            while (fgets(fid) ~= -1)
               FC = textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s ');           
            end
            fclose(fid);
            FC = FC{11};
            Temp = zeros(size(FC));
            for x = 1 : size(FC,1)
                if(FC(x,1)=="FEMALE")
                    Temp(x,1) = 1;
                else 
                    Temp(x,1) = 2;
                end
            end
        end

        if numberOfImageFiles >= 1
            % Go through all those image files.
            for f = 1 : numberOfImageFiles
                fullFileName = fullfile(thisFolder, baseFileNames(f).name);
                I = imread(fullFileName);
                I = imresize(I,[25,25]);
                %I=rgb2gray(I);
                hog_features=extractHOGFeatures(I);
                mat = zeros(1,1);
                hog_features = [hog_features mat];
                hog_features(1,145) = Temp(f,1);
                answer = cat(1,answer,hog_features);
            end 
            size(answer)
            size(Temp)
            %answer(:,60) = Temp(:,1)
        else
            fprintf('Folder %s has no image files in it.\n', thisFolder);
        end
    end
end
answer(1 ,:)=[];

