close all
clear all
% Example of analysis of data seris 
% K H Richardson 29-07-21 Queen Mary University London

%%% load data
sample10='a_Tf_1us.DSC'; %7
sample9='a_Tf_2us.DSC';%5 
sample8='a_Tf_4us.DSC';%4
sample7='a_Tf_6us.DSC';%4
sample6='a_Tf_8us.DSC'; %4
sample5='a_Tf_10us.DSC'; %5
sample4='a_Tf_15us.DSC'; %2
sample3='a_Tf_20us.DSC'; %5
sample2='a_Tf_42us.DSC';  %4
sample1='a_Tf_160us.DSC'; %4

pos1=[0.15 0.1 0.5 0.9];
subplot('Position',pos1)
s=10;
i=1;
n=3;

% plot_T_elongatus(sample, s, colour, d, n, rel, fit_weghting, phase, field_correction,gsh)
% sample - sample DSC file
% s - data smoothing
% colour - colour of plot rbg
% d - separayion of plots on y axis
% n - experiment no. 
% n=1 plots experimental absorbance data 
% n=2 plots experimental and simulated absorbance data 
% n=3 plots first derivative of experimental absorbance data 
% n=4 plots first derivative experimental and simulated from absorbance data 
% n=5 plots first derivative spectra
% n=6 plots nothing
% rel - relative intensity of signal id desired
% fit_weghting - insenties from esft
% phase - + or -
% field_correction - field correction if required
% gsh - calibration shift

% fit_weghting=[0 0 0];

sim{1}=plot_T_elongatus(sample1, s, 'k', 1*i, n, 1,[5.28927 6.89719 5.26655]*0.75, 1, 1,0.00005);
hold on 
sim{2}=plot_T_elongatus(sample2, s, 'k', 2*i, n, 1, [5.59981 7.60914 5.38101]*0.7, 1, 1,0.00005);
hold on 
sim{3}=plot_T_elongatus(sample3, s, 'k', 3*i, n, 0.8,[3.52524 12.1291 4.63689 ]*0.5, 1,1,0.00005);
hold on 
sim{4}=plot_T_elongatus(sample4, s, 'k', 4*i, n, 1,[0.41152 12.1291 5.71789 ]*0.69, 1,1,0.00005);
hold on
sim{5}=plot_T_elongatus(sample5, s, 'k', 5*i, n, 0.8,[-10.0477 37.3188 6.2896 ]*0.22, 1, 1,0.00005);
hold on
sim{6}=plot_T_elongatus(sample6, s, 'k', 6*i, n, 1, [-11.2232 23.4529 3.9686]*0.43,1,1,0.00005);
hold on 
sim{7}=plot_T_elongatus(sample7, s, 'k', 7*i, n, 1,[-22.0683 34.9334 -0.919607 ]*0.32, 1,1,0.00005);
hold on 
sim{8}=plot_T_elongatus(sample8, 2*s, 'k', 8*i, n, 1,[-29.715 30.3338 -3.46699]*0.45, 1,1,0.00005);
hold on
sim{9}=plot_T_elongatus(sample9, s, 'k', 9*i, n, 0.8,[-28.3715 9.00627 -8.3511]*0.25, 1, 1,0.00005);
hold on 
sim{10}=plot_T_elongatus(sample10, s, 'k', 10*i, n, 0.571428,[-43.6016 -3.26082 -23.1495]*0.1, 1, 1,0.00005);
hold on 

%% Plot relative signal intensities
% intgmatrix for integration of singal
% peakmatrix for peak to peak heights
int=[];
for i=1:10
    % intgmatrix(x, y, end integration, start integration)
    n2=intgmatrix(sim{i}(:,1), sim{i}(:,3), 380, 320);
    n4=intgmatrix(sim{i}(:,1), sim{i}(:,4), 380, 320);
    nx=intgmatrix(sim{i}(:,1), sim{i}(:,5), 380, 320);
    a=[n2; n4; nx];
%             t=sum(a);
%     a=(a/t)*100;
    int=[int a];
end
x=[60000 42000 20000 15000 10000 7260 6000 4000 2000 1000]; 
figure(2)

% plot as a bar chart
% b=bar(x, int',  0.5, 'stack');
% hold on
% b(1).FaceColor = 'm';
% b(2).FaceColor = rgb('purple');
% b(3).FaceColor = rgb('grey');
% ylabel('Signal intensity',  'FontSize',size);
% xlabel('\tau',  'FontSize',size);
% set(gca, 'ytick',[],'YTickLabel', [],  'FontSize',size);

% plot as dot plot
plot(x, int(1,:), '.', 'color', 'm', 'MarkerSize', 20);
hold on
plot(x, int(2,:), '.', 'color', rgb('purple'), 'MarkerSize', 20);
hold on
plot(x, int(3,:), '.', 'color', rgb('grey'), 'MarkerSize', 20);
set(gca, 'Fontsize',14);
%
xlabel('REFINE Filtration time (ns)');
xlim ([0 600]);
int_n=[];
for i=1:3
    m=max(int(i,:));
    a=int(i,:)/m;
    int_n=[int_n; a]
end

plot(x, int_n(1,:), '.', 'color', 'm', 'MarkerSize', 20)
hold on
plot(x, int_n(2,:), '.', 'color', rgb('purple'), 'MarkerSize', 20)
hold on
plot(x, int_n(3,:), '.', 'color', rgb('grey'), 'MarkerSize', 20)


%% Annotation added to figure
pos1=[0.15 0.1 0.5 0.9];
subplot('Position',pos1)
size=14;
sh=321;
shift=-0;
text(sh, -1*i+shift, 'Tf 60000',  'FontSize', size);
text(sh, -2*i+shift, 'Tf 42000',  'FontSize', size);
text(sh, -3*i+shift, 'Tf 20000',  'FontSize', size);
text(sh, -4*i+shift, 'Tf 15000',  'FontSize', size);
text(sh, -5*i+shift, 'Tf 10000',  'FontSize', size);
text(sh, -6*i+shift, 'Tf 7260',  'FontSize', size);
text(sh, -7*i+shift, 'Tf 6130',  'FontSize', size);
text(sh, -8*i+shift, 'Tf 3790',  'FontSize', size);
text(sh, -9*i+shift, 'Tf 2000',  'FontSize', size);
text(sh, -10.45*i+shift, 'Tf 1000',  'FontSize', size);
set(gca, 'ytick',[],'YTickLabel', [], 'FontSize', size);
xlim ([320 380]);
xlabel('Field (mT)'), 'FontSize', size;

xlab=364;   
text(xlab, -1*i+shift, '30%', 'color','m',  'FontSize', size);
text(xlab, -2*i+shift, '30%', 'color','m',  'FontSize', size);
text(xlab, -3*i+shift, '17%', 'color','m',  'FontSize', size);
text(xlab, -4*i+shift, '7%', 'color','m', 'FontSize', size);
text(xlab, -5*i+shift, '19%', 'color','m', 'FontSize', size);
text(xlab, -6*i+shift, '29%', 'color','m',  'FontSize', size);
text(xlab, -7*i+shift, '38%', 'color','m',  'FontSize', size);
text(xlab, -8*i+shift, '47%', 'color','m', 'FontSize', size);
text(xlab, -9*i+shift, '62%', 'color','m',  'FontSize', size);
text(xlab, -10.45*i+shift, '62%', 'color','m',  'FontSize', size);

xlab=xlab+5.5;   
text(xlab, -1*i+shift, '40%', 'color',rgb('purple'),  'FontSize', size);
text(xlab, -2*i+shift, '41%', 'color',rgb('purple'),  'FontSize', size);
text(xlab, -3*i+shift, '60%', 'color',rgb('purple'),  'FontSize', size);
text(xlab, -4*i+shift, '63%', 'color',rgb('purple'), 'FontSize', size);
text(xlab, -5*i+shift, '70%', 'color',rgb('purple'), 'FontSize', size);
text(xlab, -6*i+shift, '61%', 'color',rgb('purple'),  'FontSize', size);
text(xlab, -7*i+shift, '60%', 'color',rgb('purple'),  'FontSize', size);
text(xlab, -8*i+shift, '48%', 'color',rgb('purple'), 'FontSize', size);
text(xlab, -9*i+shift, '19%', 'color',rgb('purple'),  'FontSize', size);
text(xlab, -10.45*i+shift, ' 5%', 'color',rgb('purple'),  'FontSize', size);

xlab=xlab+5.5;   
text(xlab, -1*i+shift, '30%', 'color',rgb('grey'),  'FontSize', size);
text(xlab, -2*i+shift, '29%', 'color',rgb('grey'),  'FontSize', size);
text(xlab, -3*i+shift, '23%', 'color',rgb('grey'),  'FontSize', size);
text(xlab, -4*i+shift, '30%', 'color',rgb('grey'), 'FontSize', size);
text(xlab, -5*i+shift, '11%', 'color',rgb('grey'), 'FontSize', size);
text(xlab, -6*i+shift, '10%', 'color',rgb('grey'),  'FontSize', size);
text(xlab, -7*i+shift, ' 2%', 'color',rgb('grey'),  'FontSize', size);
text(xlab, -8*i+shift, ' 5%', 'color',rgb('grey'), 'FontSize', size);
text(xlab, -9*i+shift, '18%', 'color',rgb('grey'),  'FontSize', size);
text(xlab, -10.45*i+shift, '33%', 'color',rgb('grey'),  'FontSize', size);
text(322, -1, 'a', 'FontSize',size);
ylim([-11  1]);

