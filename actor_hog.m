clc;    % Clear the command window.
workspace;  % Make sure the workspace panel is showing.
format longg;
format compact;
%ans = zeros(1,145);
ans = zeros(1,145);

files = dir('F:\m\IMFDB_final\IMFDB_final')
files(1:2)=[];
 dirFlags = [files.isdir] 
 subFolders = files(dirFlags) 
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

%count = 1;
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
	% Now we have a list of all files in this folder.
	
	if numberOfImageFiles >= 1
		% Go through all those image files.
       
		for f = 1 : numberOfImageFiles
			fullFileName = fullfile(thisFolder, baseFileNames(f).name);
			%fprintf('     Processing image file %s\n', fullFileName);
            %fullFileName = strcat(fullFileName ,'\images\');
            I = imread(fullFileName);
           I=imresize(I,[25,25]);
            % figure, imshow(I);
          % I=rgb2gray(I);
           
            %lbp_features=extractLBPFeatures(I);
            hog_features=extractHOGFeatures(I);
            mat = zeros(1,1);
          % lbp_features = [lbp_features mat];
             hog_features = [hog_features mat];
            
            %lbp_features(1,60) = j;
            hog_features(1,145) = j;
            %ans = cat(1,ans,lbp_features); 
            ans = cat(1,ans,hog_features); 
            
            %ans(f,60) = k-1;
            
        end
      
	else
		fprintf('     Folder %s has no image files in it.\n', thisFolder);
    end
    
   
end
end

ans([1],:) = [] ;
