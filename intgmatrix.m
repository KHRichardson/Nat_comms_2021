function [int] = intgmatrix(g1, y1, int_limits, int_limite);
% g1 g values from spectra
% y1 intensity from spectria
% int_limits define start
% int_limite define end

% K H Richardson 28-07-21 Queen Mary University London

data1 = [g1(:) y1(:)];

max_area=[];
for i=int_limits;
    gs = data1(g1 < i,:); % g values below determined limit
    ys=gs(:,2);         
    areays=sum(ys(ys>0))-sum(ys(ys<0)); %sum of the area above and below
    max_area = [max_area areays];
end 

min_area=[];
for n=int_limite;
    ge = data1(g1 < n,:);
    ye=ge(:,2);
    areaye=sum(ye(ye>0))-sum(ye(ye<0));
    min_area=[min_area areaye];
end

int=[];
area=max_area'+min_area'
int=[int area];
end 