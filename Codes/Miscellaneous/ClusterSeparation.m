%% WARNING - Run cell by cell by pressing [CTRL] + [ENTER] to preserve necessary results

clear all; close all; clc;

%% Loading images
directory = '/Users/inkiyadga/Documents/Gazi Inkiyad/Beads/Data/'; % Data directory
file = dir([directory '*.tif']);
name = struct2cell(file);
filename = name{1,3};
cd(directory);
img = {};
img{1} = imread(fullfile(filename));
img{2} = img{1};

%% edge
nhood = ones(3,3);
d = 2*(rangefilt(img{2},nhood));

%% Clearer edge
imgn = (img{2} - d);

%% High Pass
imghp = 2*(img{2}-imgaussfilt(img{2},2));
imgf = imgn - imghp;

%% Reshaping image pixels into one dimension
% img1D = imgf(:);
% img1D(img1D<3*std(double(img{2}(:)))) = 0;
% L = kmeans(img1D,4, 'Replicate', 5); % More replicates more accurate, and slower it runs
% s = reshape(L,[size(img{2})]);
% s(s<2)=0;

%% Otsu method - faster but less accurate
L = graythresh(imgf);
s = imbinarize(imgf, L);
s = 255.*s./max(s);

%% Marking
b = imbinarize(uint8(s));
b = imfill(b, 'holes');
b = bwareaopen(b, 3);
%b = imclose(b, strel('disk',2));
b = bwareafilt(b, [0 80000]);
% img{2}(img{2}<3*std(double(img{2}(:)))) = 0;
% beads = imbinarize(img{2}, 'global');

%% Display
overlay = imoverlay(img{2}, b,'red');
figure(1);
im = imshow(overlay);

%% Out of Focus
InFocusMask = MaskSubtract(img{2},b);
%save([directory 'InFocusMask_Slide[slide number].mat'], 'InFocusMask');
img{1}(InFocusMask == 0) = 25;

%% Tissue and Bead Overlap
BeadsMask = MaskSubtract(img{2},InFocusMask);
BeadsMask = imdilate(BeadsMask, strel('disk', 8)); % 8 is a hyper parameter
%save([directory 'BeadsMask_Slide[slide number].mat'], 'BeadsMask');
overlay = imoverlay(img{2}, BeadsMask, 'red');

%% Tissue Only
Tissue = img{2};
Tissue(BeadsMask ==1) = 25; % 25 to blend in with the background this will be used based on calibration value
im = imshow(Tissue);
TissueMask = imbinarize(Tissue, 0.08); % 0.08 is a hyperparameter
TissueMask = MaskSubtract(Tissue,TissueMask);
TissueMask = imclose(TissueMask, strel('disk',10)); 
Tissue(TissueMask == 0) = 25;
%save([directory 'TissueMask_Slide[slide number].mat'], 'TissueMask');
imwrite(Tissue, [directory num2str(filename) '_TissueOnly.tif']);

%% Area and Circularity
geometry = regionprops(b,'Area','Perimeter');
circularity = deal((4*pi.*[geometry.Area]./[geometry.Perimeter].^2)');
figure(2);
scatter([geometry.Area], circularity); 
title('Mask Circularity vs Area'); xlabel('Area'); ylabel('Circularity');

%% Analysis
area = [geometry.Area];
analysis(:,1) = area;
analysis(:,2) = circularity;

%% Cluster based on circularity
idx = kmeans(analysis, 3, 'Replicate', 5);

