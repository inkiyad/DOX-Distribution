clear all; close all; clc
%% Bead Separation
%% Loading images
directory = '/Users/inkiyadga/Documents/Gazi Inkiyad/Beads/Data/';
file = dir([directory '*.tif']);
name = struct2cell(file);
cd(directory);
img = imread(fullfile(name{1,3}));


%% edge
nhood = ones(5,5);
d = (rangefilt(img,nhood));

%% Clearer edge
imgn = (img - d);

%% High Pass
imghp = 2*(img-imgaussfilt(img,4));
imgf = imgn - imghp;

%% Masking/Thresholding
% img_b = imbinarize(imgn,0.18);
% img_b = imfill(img_b, 'holes');
%img_b = uint8(img_b);

% imghp_b = imbinarize(imghp,0.1);
% imghp_b = imdilate(imghp_b, strel('disk',2));
% imgf = img_b - imghp_b;
% imgf(imgf<0)==0;
% imgf = logical(imgf);
imgf_b = imbinarize(imgf, 0.15);
imgf_b = bwareafilt(imgf_b, [0 30000]);
imgf_b = imopen(imgf_b, strel('disk', 4));


%% Labeling
[L, num] = bwlabel(imgf_b);
s = regionprops(L, 'Centroid');

%% Display
overlay = imoverlay(img, (imgf_b),'red');
figure(1);
imshow(overlay);
hold on
for k = 1:numel(s)
    c = s(k).Centroid;
    text(c(1)-20, c(2)+10, sprintf('%d', k), 'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', 'color', 'blue');
end

%% Area and Circularity
geometry = regionprops(L,'Area','Perimeter');
circularity = deal((4*pi.*[geometry.Area]./[geometry.Perimeter].^2)');
figure(2);
scatter([geometry.Area], circularity); 
title('Mask Circularity vs Area'); xlabel('Area'); ylabel('Circularity');