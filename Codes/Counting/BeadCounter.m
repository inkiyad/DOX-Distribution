%% WARNING - Run cell by cell by pressing [CTRL] + [ENTER] to preserve necessary results

clear all; close all; clc;

CodeDir = pwd;
addpath(genpath('..'));

%% Loading images
directory = '../../Data/Tissue Samples'; % Data directory to Tissue Samples
cd(directory); % change directory to [directory]
sample = dir('W*'); % Locate all the woodchuck tumor images *W* locates all folders W as a name

for i=1:length(sample) % can control how many images to be manually segmented per session
    % Implementing to automate the process
    cd(sample(i).name); % change directory to [sample directory] with image
    file = dir('W*.tif'); % locate all images that has name starting with W
    filename = file.name; % extracting string from a struct
    img = imread(fullfile(filename)); % reading the image file
    load(fullfile('BeadMask.mat')); % loads up beads mask from otsu segmentation variable b


    %% Labeling
    [L, num] = bwlabel(BeadMask);
    s = regionprops(L, 'Centroid');
    
    %% Display
    overlay = imoverlay(img, BeadMask,'red');
    figure(1);
    imshow(overlay);
    hold on
    for k = 1:numel(s)
        c = s(k).Centroid;
        text(c(1)-20, c(2)+10, sprintf('%d', k), 'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle', 'color', 'yellow');
    end
    
    %% Area and Circularity
    geometry = regionprops(L,'Area','Perimeter');
    circularity = deal((4*pi.*[geometry.Area]./[geometry.Perimeter].^2)');
    Area = [geometry.Area];
    figure(2);
    scatter([geometry.Area], circularity);
    title('Mask Circularity vs Area'); xlabel('Area'); ylabel('Circularity');
    
    %% Saving
    save('Count&Geometry.mat', 'num', 'geometry');
    
    %% Progress - Just to see the progress of the code
    progress = i;
    progress = i/length(sample)*100;
    disp([num2str(progress) '%']);
    
end

cd(CodeDir);