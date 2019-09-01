%% WARNING - Run cell by cell by pressing [CTRL] + [ENTER] to preserve necessary results

clear all; close all; clc;

CodeDir = pwd;
addpath(genpath('..'));

%% Loading images
load('OtsuThresholdBead.mat'); % Loading otsu's threshold for bead
directory = '../../Data/Tissue Samples'; % Data directory to Tissue Samples
cd(directory); % change directory to [directory]
sample = dir('W*'); % Locate all the woodchuck tumor images *W* locates all folders W as a name

for i=1:length(sample)
    % Implementing to automate the process
    cd(sample(i).name); % change directory to [sample directory] with image
    file = dir('W*.tif'); % locate all images that has name starting with W
    filename = file.name; % extracting string from a struct
    img = imread(fullfile(filename)); % reading the image file
    
    
    %% Bead Segmentation
    % edge - finds the edges of the image
    nhood = ones(3,3);
    d = 2*(rangefilt(img,nhood));
    
    % Clearer edge - first set of filter to have a sharper edge
    imgn = (img - d);
    
    % High Pass - subtracting gaussian filter from image to produce a high
    %             pass filter then applying 2nd layer of filter to make a
    %             sharper image which will be easier to distinguish beads
    imghp = 2*(img-imgaussfilt(img,2));
    imgf = imgn - imghp;
    
    % Otsu method to get the graythreshold
    s = imbinarize(imgf, L); % Binarizing based on otsu threshold L
    
    BeadMask = imfill(s, 'holes'); % filling hole - morphological operation
    BeadMask = bwareaopen(BeadMask, 5); % opening up binarized areas that are less than 5 px^2
    %b = imclose(b, strel('disk',2));
    BeadMask = bwareafilt(BeadMask, [2 80000]); % filtering for binarized area between 2 to 80000 px^2
    BeadMask = imdilate(BeadMask, strel('disk', 9)); % finally dilating the beads mask by 9 units radially
    %                                    so it covers the entire bead
    %                                    region.
    
    overlay = imoverlay(img, BeadMask, 'red'); % overlay of the beadmask and image
    imshow(overlay); % display
    
    save('BeadMask.mat','BeadMask'); % saving the mask as .mat file
    
    cd('..'); % going back to the main directory
    
    %% Progress - Just to see the progress of the code
    progress = i;
    progress = i/length(sample)*100;
    disp([num2str(progress) '%']);
end

cd(CodeDir);