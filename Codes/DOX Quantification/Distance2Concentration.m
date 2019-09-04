%% WARNING - Run cell by cell by pressing [CTRL] + [ENTER] to preserve necessary results

clear all; close all; clc;

CodeDir = pwd;
addpath(genpath('..'));

%% Loading images
directory = '../../Data/Tissue Samples'; % Data directory to Tissue Samples
cd(directory); % change directory to [directory]
sample = dir('W*'); % Locate all the woodchuck tumor images *W* locates all folders W as a name

SaveDirectory = '../Stats/';

% Conversion
px2micro = 1.29; % 1.29µm/1px
micro2mm = 1/1000; % 1µm/1000mm

% Max distance
MaxDistance = 200;

% # Sample of pixels
NumSamples = 100;

count = 1;

 for i=1:length(sample)
    % Implementing for loop to automate the process with multiple samples
    cd(sample(i).name); % change directory to [sample directory] with image
    file = dir('Smu*.tif'); % locate all images that has name starting with W
    filename = file.name; % extracting string from a struct
    load(fullfile('TissueMask.mat'));
    load(fullfile('BeadCluster.mat'));
    img = imread(fullfile(filename)); % reading the image file
    ClusterOverlay = imoverlay(img, ClusterMask, 'red');

    ROI = zeros(size(img)); % Empty ROI mask that will be populated by
                            % logical values to sample pixels from distance
    



    %% Figure 1 to segment ROI
    figure(1)
    imshow(ClusterOverlay);
    hold on;
    % Display area of the beads clusters
    for k = 1:numel(GeometryCluster)
        c = GeometryCluster(k).Centroid;
        area = GeometryCluster(k).Area*(px2micro^2)*(micro2mm^2);
        text(c(1)-20, c(2)+10, sprintf('%d mm^{2}', area), 'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle', 'color', 'yellow');
    end
    
    FigureNum = 2;
    ROI = MaskAdd(ClusterOverlay, ROI, FigureNum); % Select the region to analyze distance for
   
    
    Distance = bwdist(ROI,'euclidean'); % Distance image of the ROI
    Distance = round(Distance);
    
    Dist2Int = zeros(MaxDistance, NumSamples);
    for d=1:MaxDistance % sampling 
        DistIndx = zeros(size(Distance)); % make a zero matrix for indexing respective distance
        DistIndx(Distance==d)=1; % marking which distance we want to sample
        DistIndx = DistIndx & TissueMask == 1; % Only sampling tissue region
        Cocentric = [img(DistIndx)];
        % randomly selecting 1000 pixels and their respective intensities
        Dist2Int(d,:) = Cocentric([randi(length(Cocentric), NumSamples,1)]);   
    end
        
    Dist2Int = mean(Dist2Int,2);
    Dist2Con(:,count,1) = int2con(Dist2Int); %µg/ml
    Disr2Con(:,count,2) = input('Please Enter Bead Cluster Area (mm^2) ');
    Dist = 1:MaxDistance;
    Dist = Dist'.*(px2micro);
    
    save([SaveDirectory filename '_Dist2Con.mat'], 'Dist2Int');
    
    cd('..');
    
    figure(3);
    plot(Dist, Dist2Con,'LineWidth', 3, 'Color', 'red'); 
    title('DOX Penetration 45 Minutes Post TACE', 'FontSize', 20);
    xlabel('Distance (µm)', 'FontSize', 18); 
    ylabel('DOX Concentration (µg/mL)', 'FontSize', 18);
    ylim([0 inf]); xlim([0 MaxDistance*px2micro]);
    set(gca, 'FontSize', 16);
    
    
    %% Progress - Just to see the progress of the code
%     s = i
%     progress = i/length(sample)*100;
%     disp([num2str(progress) '%']);
    
 end

cd(CodeDir);
