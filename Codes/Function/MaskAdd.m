function [out] = MaskAdd(img,input_mask,figure_num)
overlay = imoverlay(img,input_mask, 'red');
figure(figure_num);
imshow(overlay);
title({'Manually Adding: Drag the mouse to select a region'});
xlabel({'Once region is selected press [Enter] to continue or [R] to not count the selected region'});
overlap = seg();
out = input_mask + overlap;
out(out<0) = 0;
out(out>1) = 1;
out = logical(out);
end