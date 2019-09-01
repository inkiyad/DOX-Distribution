clear all; close all; clc;

%% Single Bead Exposure analysis
concentration = '10 mg';

%% Loading data
directory = 'D:\Gazi Inkiyad\Beads\';
addpath(genpath([directory 'Code'])); % adding path 
RawData = [directory 'Raw\Single Bead Calibration\' concentration '\'];
cd(RawData);
load('BeadMask.mat');
expTime = [400, 100, 75, 50, 40, 30, 25, 20, 15]; 
avgIntensity = zeros(9,1);
for l=1:9
    file = [num2str(expTime(l)) ' ms.tif'];
    im = imread(fullfile(file));
%     thresh = graythresh(im);
%     im_b = imbinarize(im,thresh);
%     im_b = imerode(im_b, strel('disk', 5));
    overlay = imoverlay(im, beadMask, 'red');
    imshow(overlay);
    beadIntensity = im(:);
    avgIntensity(l,1)= mean(beadIntensity(beadMask(:)==1));
end
    
%% plotting the mean intensity 

figure(2);
scatter(expTime, avgIntensity); title([concentration '/ml Intensity Curve']);
xlabel('Exposure time'); ylabel('Average Intensity');
    
save('ExposureStandard.mat', 'avgIntensity');


