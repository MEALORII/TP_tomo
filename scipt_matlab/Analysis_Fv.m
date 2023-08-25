
close all
clear all 

load('External_NT4_L.mat');
load('Internal_NT4_L.mat');

% Evolution of diameter as a function of Z 

figure; hold on;
[Dmin0, ind_min0] = min(sqrt(ExternalNT4LStep01(:,2)/pi));
plot([1:length(ExternalNT4LStep01(:,2))]-ind_min0, sqrt(ExternalNT4LStep01(:,2)/pi), '-o', 'markersize', 3);
[Dmin1, ind_min1] = min(sqrt(ExternalNT4LStep06(:,2)/pi));
plot([1:length(ExternalNT4LStep06(:,2))]-ind_min1, sqrt(ExternalNT4LStep06(:,2)/pi), '-o', 'markersize', 3);
[Dmin2, ind_min2] = min(sqrt(ExternalNT4LStep13(:,2)/pi));
plot([1:length(ExternalNT4LStep13(:,2))]-ind_min2, sqrt(ExternalNT4LStep13(:,2)/pi), '-o', 'markersize', 3);
axis equal
title('Radius of cross-sections as a function of Z position')
xlabel('Z position')
ylabel('Diameter [pixels]')

% Compare strain over the whole FOV (i.e. pseudo-extensometer strain) with the local strain in the central cross-section 

figure; hold on;
Eps_average = log([641 860 937]/641); % directly given by the height of the CT volume
Eps_loc = 2*log(Dmin0./[Dmin0 Dmin1 Dmin2]);
plot(Eps_average, Eps_loc, 'o')
plot([0 0.5], [0 0.5], '--r')
title('Average strain VS Local strain in minimum cross-section')
xlabel('Pseudo-extensometer strain')
ylabel('Local strain in the central cross-section')
% 

% Plot the evolution of the local strain as a function of the Z position

figure; hold on;

Fv_0 = zeros(length(ExternalNT4LStep01(:,2)),1);
for z=1:length(ExternalNT4LStep01(:,2))
    Fv_0(z) = sum(InternalNT4LStep01(find(InternalNT4LStep01(:,4)==z),2))/ExternalNT4LStep01(z,2);
end
% Index of slices containing ring artefacts
ind_ring = [361:362 470:473 620:625]; Fv_0(ind_ring) = NaN; 
plot([1:length(ExternalNT4LStep01(:,2))]-ind_min0, Fv_0, '-o', 'markersize', 3);

Fv_1 = zeros(length(ExternalNT4LStep06(:,2)),1);
for z=1:length(ExternalNT4LStep06(:,2))
    Fv_1(z) = sum(InternalNT4LStep06(find(InternalNT4LStep06(:,4)==z),2))/ExternalNT4LStep06(z,2);
end
% Index of slices containing ring artefacts
ind_ring = [339:341 482:483 496:500 517:521 570:573]; Fv_1(ind_ring) = NaN; 
plot([1:length(ExternalNT4LStep06(:,2))]-ind_min1, Fv_1, '-o', 'markersize', 3);

Fv_2 = zeros(length(ExternalNT4LStep13(:,2)),1);
for z=1:length(ExternalNT4LStep13(:,2))
    Fv_2(z) = sum(InternalNT4LStep13(find(InternalNT4LStep13(:,4)==z),2))/ExternalNT4LStep13(z,2);
end
% Index of slices containing ring artefacts
ind_ring = [2:17 361:363 504:506 519:522 539:544 592:595]; Fv_2(ind_ring) = NaN; 
plot([1:length(ExternalNT4LStep13(:,2))]-ind_min2, Fv_2, '-o', 'markersize', 3);

xlabel('Z position')
ylabel('Local strain in the cross-section(Z)')
%

figure; hold on;
delta = 100;
plot(zeros(size(Fv_0((ind_min0-delta):(ind_min0+delta)))), Fv_0((ind_min0-delta):(ind_min0+delta)), 'o', 'markersize', 3);
EpsLoc_1 = 2*log(sqrt(ExternalNT4LStep01((ind_min0-delta):(ind_min0+delta),2)/pi)./sqrt(ExternalNT4LStep06((ind_min1-delta):(ind_min1+delta),2)/pi));
EpsLoc_2 = 2*log(sqrt(ExternalNT4LStep01((ind_min0-delta):(ind_min0+delta),2)/pi)./sqrt(ExternalNT4LStep13((ind_min2-delta):(ind_min2+delta),2)/pi));
plot(EpsLoc_1, Fv_1((ind_min1-delta):(ind_min1+delta)), 'o', 'markersize', 3);
plot(EpsLoc_2, Fv_2((ind_min2-delta):(ind_min2+delta)),'o', 'markersize', 3);
plot([0  mean(EpsLoc_1) mean(EpsLoc_2)], [nanmean(Fv_0((ind_min0-delta):(ind_min0+delta)))  nanmean(Fv_1((ind_min1-delta):(ind_min1+delta))) nanmean(Fv_2((ind_min2-delta):(ind_min2+delta)))], '-ok'); 
xlabel('\epsilon_{Loc}');
ylabel('Void area fraction in each slice (F_A)');
legend(sprintf('Scan 1: F_v = mean(F_A) = %f',nanmean(Fv_0((ind_min0-delta):(ind_min0+delta)))), sprintf('Scan 6: F_v = mean(F_A) = %f',nanmean(Fv_1((ind_min1-delta):(ind_min1+delta)))), sprintf('Scan 13: F_v = mean(F_A) = %f',nanmean(Fv_2((ind_min2-delta):(ind_min2+delta)))))
