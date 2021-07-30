clear all
close all

% K H Richardson 29-07-21 Queen Mary University London

%%% Load sample 
sample='sample.DSC';

%%% Field shift if required
% y=[240.08, 264.1, 289, 313, 337,361,385,409,432,457,481];
% x=[200, 220, 240, 260, 280, 300, 320,340, 360, 380, 400];
% p = polyfit(x,y,1);
% yfit= p(1)*x + p(2);
p=[1 0];

%%% Scaling and baseline correction 
opt2=[5 5 1 0 0]; %options for cwscale and scale respectively
[b y1 par]=eprload(sample); %det FS
b=p(1)*b + p(2);
y1=real(y1);
[b1 y1 mw1]=cwscale(y1,par);   %view baseline correction
b1=p(1)*b1 + p(2);
y1=scale(b1,y1,opt2);


%%% Experimental parameters
% h=6.626e-34; u=9.274e-27; v=str2num(par.FrequencyMon(1:8))*1e3; g=0.00007;
% b0=(h*v)/(u*g); %G
% b=b-(b0/10); %mT
% b1=b1-(b0/10);
Exp1.mwFreq=str2num(par.FrequencyMon(1:8));            % Experimental microwave frequency
Exp1.Range=[min(b1) max(b1)];           % Experimental microwave field range
Exp1.Harmonic=1;                % Harmonic (0 = absorption, 1 = first derivative)
Exp1.nPoints=length(b1);  % Number of experminetal points

%%%  Simulation g values, strain ect.
gStrainN2=[0.0111898 0.0091898 0.00872419];     
gStrainNx=[0.0375913 0.0200503 0.0271627];
gStrainN4=[ 0.014255 0.0169129  0.00872419];

N2= [ 1.922 1.922 2.0552 ];
Nx  =[1.85207 1.89978  2.06434 ];
N4  =[1.90715 1.91334  2.04521  ];

%%% Simulation parameters
Sys1.Nucs='56Fe';               % Paramagnetic nucleus
Sys1.g=N2;     % g values
Sys1.A=[0 0 0];                 % Hyperfine coupling
Sys1.gStrain=gStrainN2;       % Inhomogenous line broadening
%Sys1.lw = 2.5;                 % Homogenous line broadening
Sys2.Nucs='56Fe';               % Paramagnetic nucleus
Sys2.g=Nx;     % g values
Sys2.A=[0 0 0];                 % Hyperfine coupling
Sys2.gStrain=gStrainNx;;       % Inhomogenous line broadening
%Sys1.lw = 2.5;                 % Homogenous line broadening
Sys3.Nucs='56Fe';               % Paramagnetic nucleus
Sys3.g=N4;     % g values
Sys3.A=[0 0 0];                 % Hyperfine coupling
Sys3.gStrain=gStrainN4;       % Inhomogenous line broadening
%Sys1.lw = 2.5;                 % Homogenous line broadening

Sys1.weight=0.805373  ;
Sys2.weight=1.2;
Sys3.weight= 0.815373 ;

Sys0={Sys1 Sys2 Sys3} %Sys2 Sys3
Vary1.weight=1;
Vary2.weight=1;
Vary3.weight=1;
FitOpt.Method = 'montecarlo';
FitOpt.Scaling = 'lsq1';


%%% Parameters to vary 
% Vary1.g=[0.001 0.001  0.001];
% Vary1.gStrain=[0.001 0.001 0.001];
% Vary2.g=[0.01 0.01 0.01];
% Vary2.gStrain=[0.015 0.015 0.015];
% Vary3.g=[0.01 0.01 0.01];
% Vary3.gStrain=[0.01 0.01 0.01];
Vary0={Vary1 Vary2 Vary3} %Vary2 Vary3 
Exp0={Exp1};
%%% Run esfit
esfit(@pepper, y1, Sys0, Vary0, Exp1, [],FitOpt);