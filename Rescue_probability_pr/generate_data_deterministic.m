% This code was created by Loïc Marrec

clear all;
close all;

% Parameter values

K = 100;                 % Carrying capacity
NW0 = 90;                % Initial number of wild-type individuals
NM0 = 0;                 % Initial number of mutant individuals
tau = 20 : 2 : 80;       % Environment duration
bWF = 1;                 % Wild-type birth rate in a favorable environment 
dWF = .1;                % Wild-type death rate in a favorable environment
bWH = 0;                 % Wild-type birth rate in a harsh environment  
dWH = .1;                % Wild-type death rate in a harsh environment   
bMF = 1;                 % Mutant birth rate in a favorable environment 
dMF = .1;                % Mutant death rate in a favorable environment
bMH = 1;                 % Mutant birth rate in a harsh environment  
dMH = .1;                % Mutant death rate in a harsh environment 
Nit = 1e3;               % Number of stochastic realizations
mu = 1e-5;               % Mutation probability upon division

% Data generation

for i = length(tau) : -1 : 1 
    
    NMlist(i, :) = Gillespie_deterministic(Nit, bWF, bWH, dWF, dWH, NW0, bMF, bMH, dMF, dMH, NM0, K, tau(i), mu);
    
    Say = sprintf('%d/%d', i, length(tau));
    disp(Say)
    
    pr(i) = length(NMlist(i, NMlist(i, :) ~= 0))/Nit;
    
end

% Data saving

fname = sprintf('pr_vs_tau_deterministic_mu%d.mat', mu);
save(fname)

% Data plotting

fig = figure('Name','Rescue probability - Deterministic environmental fluctuations','NumberTitle','off');
hold on  
    
    psim = plot(tau, pr, 'LineStyle', 'None', 'Marker', 'o', 'Color', 'k', 'Linewidth', 1.5);

hold off
hXLabel = xlabel('Environment duration \tau', 'Color', 'k');
hYLabel = ylabel('Rescue probability p_r', 'Color', 'k');
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
ylim([0 1])
