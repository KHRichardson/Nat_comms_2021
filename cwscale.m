
function [b y1 mw]=cwscale(y,par)

% b field [mT]
% mw GHz


opt.temp='';
% Ensure power scaling option
if isfield(opt,'power')==0; opt.power='n'; end
    

if isfield(par,'Gain')==1

 Gain_dB=par.Gain(1:end-2);     % dB
 Gain_dB=str2num(Gain_dB);      % dB
 Gain=10^(Gain_dB/20);          % number
elseif isfield(par,'RRG')==1
 Gain=(par.RRG);
else
 Gain=1;
end

if isfield(par,'VideoGain')==1
 % Gain conversion
 VideoGain=par.VideoGain(1:end-2);
 VideoGain=str2num(VideoGain);
 Gain=10^(VideoGain/20); 
end

  if isfield(par,'Power')==1                % Power conversion
   Power=str2num(par.Power(1:end-2))/1e3;   % W power
  elseif isfield(par,'MP')==1               % Power conversion
   Power=(par.MP)/1e3;               % W power
  end
%end
%}


if isfield(par,'NbScansDone')==1
 NbScansDone=(par.NbScansDone);
elseif isfield(par,'JSD')==1
 NbScansDone=(par.JSD); 
else
 NbScansDone=1;
end

if NbScansDone<1
    NbScansDone=1;
    
end

% Amplitude
%y1=y/NbScansDone/sqrt(Power)/Gain;
%y1=y/sqrt(Power)/Gain;
%y1=y/NbScansDone/Gain;
%y1=y/sqrt(Power);
y1=y;


if isfield(par,'XMIN')==1
 % field mT
 XMIN=(par.XMIN);
 XWID=(par.XWID);
 XPTS=(par.XPTS);
 b=( XMIN:(XWID/(XPTS-1)):(XMIN+XWID) )' / 10;
elseif isfield(par,'HCF')==1
 XMIN=(par.GST);
 XWID=(par.GSI);
 XPTS=(par.ANZ);
 b=( XMIN:(XWID/(XPTS-1)):(XMIN+XWID) )' / 10;
end

if isfield(par,'FrequencyMon')==1
 mw=str2num(par.FrequencyMon(1:end-3));  
elseif isfield(par,'MF')==1
 mw=(par.MF);  
else
 mw=0;
end

if isfield(par,'TITL')==1
   TITL=par.TITL;
elseif isfield(par,'JCO')==1
   TITL=par.JCO;
else 
   TITL='no entry';
end   

if isfield(par,'ModAmp')==1
 ModAmp=(par.ModAmp);  
else
 ModAmp='no entry';
end


%}