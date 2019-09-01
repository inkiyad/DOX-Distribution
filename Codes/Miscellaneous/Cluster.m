clear all; close all; clc;

%% Loading images
directory = 'C:\Users\inkiyadga\Documents\Beads\Data\';
file = dir([directory '*.tif']);
name = struct2cell(file);
cd(directory);
img = imread(fullfile(name{1,3}));

%% k means

i = kmeans(double(img),4, 'Replicate', 4);