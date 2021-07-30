function [heights] = peakmatrix(g1, y1, peak_limits);


% K H Richardson 28-07-21 Queen Mary University London
    
data1 = [g1(:) y1(:)];

% find the g value closest to the feature of interest

gvalues=[];
for i=peak_limits
    [val,idx]=min(abs(g1-i));
    closest=g1(idx);
    
    index = find(g1==closest);
    Y_point = y1(index);

    gvalues = [gvalues Y_point];
end


% Calculate peak heights 
 C1z=gvalues(2)-gvalues(1);
 C1xy=gvalues(3)-gvalues(1);
 C2z=gvalues(4)-gvalues(1);
 C2x=gvalues(5)-gvalues(1);
 C2y=gvalues(6)-gvalues(1);
 C3z=gvalues(7)-gvalues(1);
 C3x=gvalues(8)-gvalues(1);
 C3y=gvalues(9)-gvalues(1);
 
 heights=[ C1z C1xy C2z C2x C2y C3z C3x C3y];
 heights= [heights'];
end

