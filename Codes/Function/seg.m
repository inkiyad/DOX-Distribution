% Segment in/out beads/tissues using imfreehand
% input is a plot
function [s] = seg(b)
m = 0;
k = 1;
while k>0;
    q = imfreehand(); % Getting ROIs
    q = createMask(q);
    s(:,:,m+1) = q;
    m = k-m;
    k = k+1;
    prompt = ['Done? (Press [ENTER] to continue or [Y] to finish) \n' ...
             '      (Press [R] to not count that region)  '];
    in = input(prompt, 's');
    if isempty(in)
        s = sum(s, 3);
        continue
    elseif in=='r'
        continue
    else
        s = sum(s, 3);
        s = logical(s);
        break
    end
end
end