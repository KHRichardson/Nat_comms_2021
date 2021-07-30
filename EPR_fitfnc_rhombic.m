function s0 = EPR_fitfnc_rhombic(p,b0,opt)

% System variables
Sys.S=1/2;
Sys.g=[p(1) p(2) p(3)];
Sys.gStrain =abs([p(4) p(5) p(6)]);
Sys.HStrain =abs([p(7) p(8) p(9)]);

% Simulation
Exp = struct('Range',[b0(1) b0(end)],'mwFreq',opt.mw, 'Harmonic',opt.Harmonic,'nPoints',length(b0));
[bs,s0]=pepper(Sys,Exp); bs=bs'; s0=s0';

if opt.Harmonic>0;
s0=s0/(trapz(b0,(cumtrapz(b0,s0)))); 
else 
s0=s0/(trapz(b0,s0)); 
end