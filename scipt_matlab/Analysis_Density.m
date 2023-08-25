
close all
clear all 

load('External_NT4_L.mat')
load('Internal_NT4_L.mat');
load('Statistics_3D.mat');

Stat3D_NT4_L_01 = [Statistics_NT4_L_Step_01_275_383.Volume_micrometer_3_ Statistics_NT4_L_Step_01_275_383.NbOfObj_Voxels Statistics_NT4_L_Step_01_275_383.X Statistics_NT4_L_Step_01_275_383.Y Statistics_NT4_L_Step_01_275_383.Z];
Stat3D_NT4_L_06 = [Statistics_NT4_L_Step_06_367_532.Volume_micrometer_3_ Statistics_NT4_L_Step_06_367_532.NbOfObj_Voxels Statistics_NT4_L_Step_06_367_532.X Statistics_NT4_L_Step_06_367_532.Y Statistics_NT4_L_Step_06_367_532.Z];
Stat3D_NT4_L_13 = [Statistics_NT4_L_Step_13_390_589.Volume_micrometer_3_ Statistics_NT4_L_Step_13_390_589.NbOfObj_Voxels Statistics_NT4_L_Step_13_390_589.X Statistics_NT4_L_Step_13_390_589.Y Statistics_NT4_L_Step_13_390_589.Z];

% Index of slices of the subvolumes used for 3D analysis [to decrease computation time]
slice_step01 = [275:383];
slice_step06 = [367:532];
slice_step13 = [390:589];

% Index of slices containing ring artefacts
ind_ring01 = [361:362 470:473 620:625];  
ind_ring06 = [339:341 482:483 496:500 517:521 570:573];  
ind_ring13 = [2:17 361:363 504:506 519:522 539:544 592:595];  


[Dmin0, ind_min0] = min(sqrt(ExternalNT4LStep01(slice_step01,2)/pi));
[Dmin1, ind_min1] = min(sqrt(ExternalNT4LStep06(slice_step06,2)/pi));
[Dmin2, ind_min2] = min(sqrt(ExternalNT4LStep13(slice_step13,2)/pi));


figure; hold on;

Nv_0 = zeros(length(slice_step01),1);
it = 1;
for z= slice_step01
    Nv_0(it) = length(InternalNT4LStep01(find(InternalNT4LStep01(:,4)==z),2))/ExternalNT4LStep01(z,2);
    if sum(find(ind_ring01==z))>0
        Nv_0(it) = NaN
    end
    it = it+1;
end
plot(linspace(0,1,length(slice_step01)), Nv_0, '-o', 'markersize', 3);

Nv_1 = zeros(length(slice_step06),1);
it = 1;
for z= slice_step06
    Nv_1(it) = length(InternalNT4LStep06(find(InternalNT4LStep06(:,4)==z),2))/ExternalNT4LStep06(z,2);
    if sum(find(ind_ring06==z))>0
        Nv_1(it) = NaN
    end
    it = it+1;
end
plot(linspace(0,1,length(slice_step06)), Nv_1, '-o', 'markersize', 3);

Nv_2 = zeros(length(slice_step13),1);
it = 1;
for z= slice_step13
    Nv_2(it) = length(InternalNT4LStep13(find(InternalNT4LStep13(:,4)==z),2))/ExternalNT4LStep13(z,2);
    if sum(find(ind_ring13==z))>0
        Nv_2(it) = NaN;
    end
    it = it+1;
end
plot(linspace(0,1,length(slice_step13)), Nv_2, '-o', 'markersize', 3);
% 
% 
xlabel('Normalized Z position')
ylabel('Local density of voids N_A');


Eps_average = log([641 860 937]/641); % directly given by the height of the CT volume
figure; hold on;
plot(Eps_average, [nanmean(Nv_0) nanmean(Nv_1) nanmean(Nv_2)], '-o', 'markersize', 3);
% plot(Eps_average, [max(Nv_0) max(Nv_1) max(Nv_2)], '-o', 'markersize', 3);
plot(Eps_average, [length(Stat3D_NT4_L_01(:,1))/sum(ExternalNT4LStep01(slice_step01,2)) length(Stat3D_NT4_L_06(:,1))/sum(ExternalNT4LStep06(slice_step06,2)) length(Stat3D_NT4_L_13(:,1))/sum(ExternalNT4LStep13(slice_step13,2))], '-o', 'markersize', 3);
xlabel('\epsilon_{Loc}');
ylabel('Density of voids');
legend('Average of [N_A]', '[N_V]');


figure; hold on;
delta = 20;
plot(zeros(size(Nv_0((ind_min0-delta):(ind_min0+delta)))), Nv_0((ind_min0-delta):(ind_min0+delta)), 'o', 'markersize', 3);
EpsLoc_1 = 2*log(sqrt(ExternalNT4LStep01((ind_min0-delta):(ind_min0+delta),2)/pi)./sqrt(ExternalNT4LStep06((ind_min1-delta):(ind_min1+delta),2)/pi));
EpsLoc_2 = 2*log(sqrt(ExternalNT4LStep01((ind_min0-delta):(ind_min0+delta),2)/pi)./sqrt(ExternalNT4LStep13((ind_min2-delta):(ind_min2+delta),2)/pi));
plot(EpsLoc_1, Nv_1((ind_min1-delta):(ind_min1+delta)), 'o', 'markersize', 3);
plot(EpsLoc_2, Nv_2((ind_min2-delta):(ind_min2+delta)),'o', 'markersize', 3);
plot([0  mean(EpsLoc_1) mean(EpsLoc_2)], [nanmean(Nv_0((ind_min0-delta):(ind_min0+delta)))  nanmean(Nv_1((ind_min1-delta):(ind_min1+delta))) nanmean(Nv_2((ind_min2-delta):(ind_min2+delta)))], '-ok'); 
xlabel('\epsilon_{Loc}');
ylabel('N_V');


