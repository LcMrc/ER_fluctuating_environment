% This code was created by Loïc Marrec

clear all;
close all;

% Parameter values

K = 100;                % Carrying capacity
N0 = 90;                % Initial population size
tau = 20 : 2 : 80;      % Environment duration
bF = 1;                 % Wild-type birth rate in a favorable environment 
dF = .1;                % Wild-type death rate in a favorable environment
bH = 0;                 % Wild-type birth rate in a harsh environment  
dH = .1;                % Wild-type death rate in a harsh environment        
Nit = 1e3;              % Number of stochastic realizations
sigma = 1;              % Standard deviation of the environmental fluctuations

% Data generation

for i = length(tau) : -1 : 1
    
    T0list(i, :) = Gillespie_stochastic(bF, dF, bH, dH, K, N0, tau(i), sigma, Nit);
    
    Say = sprintf('%d/%d', i, length(tau));
    disp(Say)
    
end

% Compute the mean extinction time, the standard deviation, and the
% 95% confidence interval

T0mean = nanmean(T0list, 2);
T0std = nanstd(T0list, 0, 2);
T0ci = 1.96.*T0std./sqrt(Nit);

% Save the data

fname = sprintf('T0_vs_tau_stochastic_sigma%d.mat', sigma);
save(fname)

% Plot the data

fig = figure('Name','Extinction time - Stochastic environmental fluctuations','NumberTitle','off');
hold on  
    
    psim = errorbar(tau, T0mean, T0ci, 'LineStyle', 'None', 'Marker', 'o', 'Color', 'k', 'Linewidth', 1.5);

hold off
hXLabel = xlabel('Environment duration \tau', 'Color', 'k');
hYLabel = ylabel('Mean extinction time T_0', 'Color', 'k');
yticks([1e1 1e2 1e3 1e4 1e5 1e6 1e7])
yticklabels({'10^1','10^2','10^3','10^4','10^5','10^6','10^7'})
set(gca, 'YScale', 'log')
hLegend = legend([psim], {'Simulation'});
set( gca                       , ...
    'FontName'   , 'Arial'   , 'FontSize'   , 14);
set([hXLabel, hYLabel], ...
    'FontName'   , 'Arial'   , 'FontSize'   , 14);
set(hLegend, ...
    'FontName'   , 'Arial'   , 'FontSize'   , 12, 'Location', 'NorthEast');
set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'off'      , ...
  'LineWidth'   , 1         );
ax = gca;
ax.XAxis.Color = 'k';
ax.YAxis.Color = 'k';
axis tight
xlim([min(tau) max(tau)])
ylim([1e1 1e7])
