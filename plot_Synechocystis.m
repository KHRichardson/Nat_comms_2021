function [sim_data, b, v]=plot_Synechocystis(sample, s, colour, d, n, rel, fit_weghting, phase, field_correction,gsh)

% K H Richardson 29-07-21 Queen Mary University London
% sample - sample DSC file
% s - data smoothing
% colour - colour of plot rbg
% d - separayion of plots on y axis
% n - experiment no. 
% rel - relative intensity of signal id desired
% fit_weghting - insenties from esft
% phase - + or -
% field_correction - field correction if required
% gsh - calibration shift

%% Field correction 0 it none required
if field_correction==0
    p=[1 0];
elseif  field_correction==1
    % y=[240.08, 264.1, 289, 313, 337,361,385,409,432,457,481]; % Measured
    % feild
    % x=[200, 220, 240, 260, 280, 300, 320,340, 360, 380, 400]; % Field on
    % software
    p = polyfit(x,y,1);
    yfit= p(1)*x + p(2);
else
end

%% Fitting parameters 
HStrainN2=[0 0 0];     % MHz   
HStrainNx=[0 0 0];
HStrainN4=[0 0 0]; 

gStrainN2=[0.0141283 0.00952408 0.0229645];     % MHz   
gStrainNx=[0.0457205 0.0275951 0.0383507];
gStrainN4=[ 0.0304211 0.0164937 0.0227871 ];

N2= [ 1.9225 1.9225 2.05543 ];  
Nx  =[1.85071 1.86722 2.0792];
N4  =[1.88375 1.91862 2.04692 ];



%%  Plot
if n==1 || n==2 ||  n==3 || n==4|| n==6
    opt1=[0 25 0 3 1]; opt2=[20 20 1 3 0]; %options for cwscale and scale respectively
    [b y1 par]=eprload(sample); %det FS
    b=p(1)*b + p(2);
    y1=real(y1);%+imag(y1);
    [b1 y1 mw1]=cwscale(y1,par);   %view baseline correction
    b1=p(1)*b1 + p(2);
    y1=scale(b1,y1,opt2)*rel;
elseif n==5
    opt1=[100 150 1 0 0];
    [b y1 par]=eprload(sample);              % Load EPR experiment from DSC file
    [b1 y1 mw1]=cwscale(y1,par);                                                               % Scale EPR data (open cwscale to change scaling options)
    y1=scale(b1,y1,opt1)*rel; %pause                                                                 % Baseline correction (open scale for details)
    g1=calcg(mw1, b1);
end

h=6.626e-34; u=9.274e-27; v=str2num(par.FrequencyMon(1:8))*1e3; g=gsh;
b0=(h*v)/(u*g); %G
b=b-(b0/10); %mT
b1=b1-(b0/10);

if n==1
    harm=0;
elseif n==2
    harm=1;
elseif n==3
    harm=0;
elseif n==4
    harm=1;
elseif n==5
    harm=1;
elseif n==6
    harm=1;
else
end

mw=mw1; 
%b1=b1; % NB field correction
opt.mw=mw1;
opt.max=0;
opt.Harmonic=harm;

sN2  = EPR_fitfnc_rhombic(N2,b1,opt);
sNx  = EPR_fitfnc_rhombic(Nx,b1,opt);
sN4  = EPR_fitfnc_rhombic(N4,b1,opt);

% A=[sN2 sNx sN4]\y1;
% 
% sN2=sN2*A(1); sNx=sNx*A(2); sN4=sN4*A(3);
sN2=sN2*fit_weghting(1); 
sN4=sN4*fit_weghting(3);
sNx=sNx*fit_weghting(2); 
s_total=sN2 + sNx +sN4;
yd=y1;
y1=datasmooth(y1, s);
sim_data=[b1, y1, sN2, sN4, sNx];
if n==1
          b= plot(b1, (s_total-d), '-.r','linewidth',1);
          hold on
%     plot(b1, (sN2-d), 'm','linewidth',1.3);
%     hold on
%     plot(b1, (sN4-d), 'color',rgb('purple'),'linewidth',1.3);
%     hold on
%     plot(b1, (sNx-d), 'color',rgb('grey'),'linewidth',1.3);
%     
    %     b=plot(b1,phase*y1-d,'color',rgb(colour));
    %     hold on
    %     yd=phase*yd-d;
    %     sim_data=[b1, phase*y1-d];
elseif n==2
    % First derivative spectra
    h=6.626e-34; u=9.274e-27; v=str2num(par.FrequencyMon(1:8))*1e3; b2=b1*10;
    b2=b2*1e-7;
    g1=[];
    for i=b2';
        g=(h*v)/(u*i);
        g1=[g1 g];
    end
    g1=g1';
    dy=diff(y1)./diff(b1);
    dy=datasmooth(phase*dy, s);
    b=plot(g1(2:end),dy-d, 'color',rgb(colour));
    set(gca,'XDir','reverse','FontSize',10,'linewidth',1.2, 'FontWeight','bold', 'ytick',[],'YTickLabel', []);
    
    sim_data=[g1(2:end), dy-d];
%     plot(b1,s_total-i,'r--', b1,sN4-0.25-i,'m');
%     hold on
%     plot(b1,sN2-0.1-i,'color',rgb('purple'))
%     hold on
%     plot(b1,sNx-0.4-i,'color',rgb('grey'))
%     title ('TITLE')
%     xlabel ('B_0 (mT)')
%     axis ([290 380 -0.5 1.15])
%     legend ('exp.', 'sim.', 'N4 sim', 'N2 sim', 'Nx sim','Location', 'NW');
elseif n==3 
    b=plot(b1,(phase*y1)-d, 'color',rgb(colour),'linewidth',1.3);
    hold on
    plot(b1, (s_total-d), '-.r','linewidth',1);
    hold on
    plot(b1, (sN2-d), 'm','linewidth',1.3);
    hold on
    plot(b1, (sN4-d), 'color',rgb('purple'),'linewidth',1.3);
    hold on
    plot(b1, (sNx-d), 'color',rgb('grey'),'linewidth',1.3);
     sim_data=[b1, y1, sN2, sN4, sNx];
elseif n==4
    % First derivative spectra
    h=6.626e-34; u=9.274e-27; v=str2num(par.FrequencyMon(1:8))*1e3; b2=b1*10;
    b2=b2*1e-7;
    g1=[];
    for i=b2';
        g=(h*v)/(u*i);
        g1=[g1 g];
    end
    g1=g1'; dy=diff(y1)./diff(b1); dy=datasmooth(phase*dy, s);
    b=plot(g1(2:end),dy-d, 'color',rgb(colour));
    hold on 
    plot(g1, (s_total-d), 'r');
    hold on 
    plot(g1, (sN2-d-0.1), 'm');
    hold on 
    plot(g1, (sN4-d-0.2), 'color',rgb('purple'));
    hold on 
    plot(g1, (sNx-d-0.3), 'color',rgb('grey'));
    set(gca,'XDir','reverse','FontSize',10,'linewidth',1.2, 'FontWeight','bold', 'ytick',[],'YTickLabel', []);
elseif n==5
    b=plot(g1, y1);
    hold on
    plot(g1, (s_total-d)*rel, 'r');
    hold on 
    plot(g1, (sN2-d), 'm');
    hold on 
    plot(g1, (sN4-d), 'color',rgb('purple'));
    hold on 
    plot(g1, (sNx-d), 'color',rgb('grey'));
    set(gca,'XDir','reverse','FontSize',10,'linewidth',1.2, 'FontWeight','bold', 'ytick',[],'YTickLabel', []);
elseif n==6
else
end

end 

