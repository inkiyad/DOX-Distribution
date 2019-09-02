# DOX-Distribution
Quantitative analysis of doxorubicin (DOX) distribution relative to drug eluting beads in fluorescence microscopy images.

## Requirements
- MATLAB with image processing toolbox
- Grayscale fluorescent microscopy images in tif format
- Untreated samples to establish a threshold for DOX intensity detection
- Intensity to concentration calibration equation 
- Images acquired with standard exposure and settings
  (example image was taken by Hama monochrome camera with 500 ms exposure time)

Prior to running the DOX-Distribution make sure images are placed at right directory with proper naming format.
Locations for untreated and treated samples are following:
Untreated samples: /DOX-Distribution/Data/Tissue Samples/Blanks/[Sample Name].tif
Treated samples: /DOX-Distribution/Data/Tissue Samples/[Sample Name]/[Sample Name].tif

Sample Names generally starts off with 'W' 
Example included in /DOX-Distribution/Data/Tissue Samples/


## Pipeline
__1. Initialize the process by running BlankSampleAnalysis.m script:__
    * Codes --> Analysis --> BlankSampleAnalysis.m
    * The input images for this script are located at the untreated samples directory.
    * The output from this script is BlankIntensity.mat file containing average and standard deviation of untreated samples' intensities.
    
    
__2. Implement intensity to concentration calibration equation in int2con.m function:__
    * Codes --> Functions --> int2con
    
    
__3. Generate otsu's bead segmentation threshold by running OtsuThresholdGenerator.m:__
    * Codes --> Segmentation --> OtsuThresholdGenerator.m
    * The input image for this script are located at the treated samples directory.
        note: only have to select one input image that has a fair amount of beads
    * The output from this script is OtsuThresholdBead.mat located in the same directory as the script.
    
    
__4. Segment the beads by running BeadSegAuto.m script (this script will iterate through all the samples):__
    * Codes --> Segmentation --> BeadSegAuto.m
    * The input images for this script are located at the treated samples directory.
    * The output from this script is BeadMask.mat file containing binary mask for segmented beads.
    
    ** If necessary run BeadSegManual.m script to manually subtract false positive regions from the bead mask **
    
    ** This script will bring two figures, one figure will display original image and other will display image with bead mask overlay **
    
    ** Drag the mouse over the desired region. Once the region is selected press enter on the MATLAB console to add another region. If not satisfied with the previous selection, press R. After all desired regions are selected press y. **
   
   
__5. Segment the tissue by running TissueSegAuto.m script (this script will iterate through all the samples):__
    * Codes --> Segmentation --> TissueSegAuto.m
    * The input images and BeadMasks for this script are located at the treated samples directory.
    * The output from this script is TissueMask.mat file containing binary mask for segmented tissue.
    
    ** If necessary run TissueSegManual.m script to manually subtract false positive regions from the Tissue mask **
    
    ** This script will bring two figures, one figure will display image with no beads and other will display image with tissue mask overlay **
    
    ** Drag the mouse over the desired region. Once the region is selected press enter on the MATLAB console to add another region. If not satisfied with the previous selection, press R. After all desired regions are selected press y. **


__6. Denoise tissue section only by running Smoothing.m script:__
    * Codes --> Denoising --> Smoothing.m
    * The input images and TissueMasks for this script are located at the treated samples directories.
    * The output from this script is Smu13mm_[sample name].tif file (Smu is label for filtered image and 13mm is the kernel radius)
    
    
__7. Detect doxorobucin at multiple threshold in tissue by running DoxDetection.m:__
    * Codes --> DOX Quantification --> DoxDetection.m
    * The inputs consist of filtered images and average and standard deviation of untreated samples' intensities.
         - Filtered images are located at the sample directory.
         - Average and standard deviation of untreated samples' intensities are located in untreated samples directory as mentioned above.
    * The output from this script is [filtered image name]_STD_[respective threshold].mat.
        - Each output .mat file contains binary mask for doxorubicin for given threshold.
    * (Thresholds are established from untreated samples. Minimum threshold is 2 standard deviation above the average intensity and maximum threshold is 5 standard deviation above the average intensity)
    
    
__8. Combine all doxorubicin masks with respective thresholds by running MultilayerDoxMask.m:__
    * Codes --> DOX Quantification --> MultilayerDoxMask.m
    * The inputs consist of filtered image and doxorubicin detected binary masks from the previous step.
    * The output from this script is MultilayerDrugMask.mat containning a sum of all previously generated doxorubicin masks.
    
    
__9. Generate doxoubicin Heatmap to visualize spatial doxorubicin distribution by running Heatmap.m:__
    * Codes --> Display --> Heatmap.m
    * The inputs consist of original images and MultilayerMask from the treated sample directories
    * The output of this script is a heatmap figure saved as HeatmapScaleBar.tif. Red in the heatmap indicates higher concentration of doxorubicin and blue indicates lower concentration of doxorubicin.
    
    
__10. Identify bead clusters and their area by running ClusterCounter.mat:__
    * Codes --> Counting --> ClusterCounter.mat
    * The inputs consists of original images and BeadMasks from the treated sample directories.
    * The output from this script is BeadCluster.mat containing number of clusters, and area of those clusters in mm
    
    -- Cluster area filter threshold could be modified for the desired area --
    
    
__11. Map average doxorubicin concentration to distance by running Distance2Concentration.m:__
    * Codes --> DOX Quantification --> Distance2Concentration.m
    * The inputs consist of filtered image and TissueMask from the sample directory.
        - This script incorporates manual selection of the cluster to be analyzed
        - There will be two figures one of them will have area labeled and other will just have BeadCluster binary mask overlay
    * The output from this script is [filtered file name]_Dist2Con.mat.
        - the script also depicts a concentration vs distance plot.
    
    
    
## Additional Scripts
- BeadCounter.m : Counts the beads
- IndAnalysis.m and GroupAnalysis.m : Quantifies average concentration and total amount of doxorubicin present in the tissue
- GraphGenerator.m: Generates graphs from IndAnalysis.m and GroupAnalysis.m data
- MaskSlideShow.m: A slideshow of the masks (i.e beads, tissue, doxorubicin) on top of original image from the treated samples
- Exposure Calibration: Calibrating exposure to intensity and concentration
- Miscallenous: Other methods of bead segmentation and analysis (i.e kmeans)


## Acknowledgement
* Center of Clinical Oncology, Radiology and Imaging Science, NIH Clinical Center, National Institutes of Health, Bethesda, MD
* National Institutes of Biomedical Imaging and Bioengineering, National Institutes of Health, Bethesda, MD


    
    
