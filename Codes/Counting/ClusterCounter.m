%% WARNING - Run cell by cell by pressing [CTRL] + [ENTER] to preserve necessary results

clear all; close all; clc;

CodeDir = pwd;
addpath(genpath('..'));

%% Conversion
px2micro = 1.29; % ?m/px
micro2mm = 1/1000; % mm/?m

%% Area filter
MinArea = 200; % px
MaxArea = inf; % px

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

    ClusterMask = imclose(BeadMask, strel('disk',20));
    ClusterMask = bwareafilt(ClusterMask, [MinArea MaxArea]);
    
    %% Labeling
    [L, num] = bwlabel(ClusterMask);
    GeometryCluster = regionprops(L, 'Centroid', 'Area');
    
    %% Display
    overlay = imoverlay(img, ClusterMask,'red');
    figure(1);
    imshow(overlay);
    hold on
    for k = 1:numel(GeometryCluster)
        area = GeometryCluster(k).Area*(px2micro*micro2mm)^2;
        c = GeometryCluster(k).Centroid;
        text(c(1), c(2), sprintf('%d mm', area), 'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle', 'color', 'yellow');
    end
    
    
    %% Saving
    save('BeadCluster.mat', 'ClusterMask', 'GeometryCluster');
    
    %% Progress - Just to see the progress of the code
    progress = i;
    progress = i/length(sample)*100;
    disp([num2str(progress) '%']);
end

cd(CodeDir);