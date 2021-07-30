function [Y1,area]=scale(x,Y,opt);

% baseline correction and scaling
%
% x   - time or field
% y   - intensities 
% opt(1) - pts from start for baseline correction 
%          (=0 then no baseline on start)
% opt(2) - pts from end for baseline correction
%          (=0 then no baseline on end)
% opt(3) - polynomial order for baseline correction
% opt(4) - scaling: if opt==0 -> no scaling
%                   if opt==1 -> max intensity=1
%                   if opt==2 -> integrate , area=1
%                   if opt==3 -> absolute max intensity=1 
% opt(5) - plot baseline ==1 and exists

%fprintf('scale:');keyboard

pt1=opt(1);  % pts from start
pt2=opt(2);  % pts from end
n=opt(3);    % polynomial order
j=length(x);

if length(opt)<5, opt(5)=0; end  % plot graph switch

for jj=1:size(Y,2)
   
 % **** baseline correction ****
 if pt1>0 | pt2>0
     
   if pt1>0 & pt2>0 % start and end
    c=polyfit([x(1:pt1); x(j-pt2:j)],[Y(1:pt1,jj); Y(j-pt2:j,jj)],n);
   elseif pt1>0 % only start
    c=polyfit([x(1:pt1)],[Y(1:pt1,jj)],n);
   elseif pt2>0 % only end
    c=polyfit([x(j-pt2:j)],[Y(j-pt2:j,jj)],n); 
   end
   
   if opt(5)==1
    figure(1)
    plot(x,Y(:,jj),'r',x,Y(:,jj)-polyval(c,x),'--r',x,polyval(c,x),'--k')
    drawnow
   end
   Y1(:,jj)=Y(:,jj)-polyval(c,x);
 else
   Y1=Y;
 end
 
 area=1;
 if opt(4)==1
    % maximum amplitude = 1
    area=max(Y1(:,jj));
 elseif opt(4)==2  
    % area = 1
    y1=cumtrapz(x,Y1(:,jj));   % intergrate
    area=trapz(x,y1);          % total area
    
    if opt(5)==1
      figure(2)
      yarea=cumtrapz(x,y1);
      plot(x,Y1(:,jj)/max(Y1(:,jj)),x,y1/max(y1),x,yarea/max(yarea))
      drawnow
    end
    
 elseif opt(4)==3
    % scale from max. intensity
    area=max(abs(Y1(:,jj)));   
 end
 
 Y1(:,jj)=Y1(:,jj)/area; 
 
end
