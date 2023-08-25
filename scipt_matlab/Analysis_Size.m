
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

Size_0 = zeros(length(slice_step01),1);
it = 1;
for z= slice_step01
    Size_0(it) = sqrt(mean(InternalNT4LStep01(find(InternalNT4LStep01(:,4)==z),2))/pi);
    if sum(find(ind_ring01==z))>0
        Size_0(it) = NaN
    end
    it = it+1;
end
plot(linspace(0,1,length(slice_step01)), Size_0, '-o', 'markersize', 3);

Size_1 = zeros(length(slice_step06),1);
it = 1;
for z= slice_step06
    Size_1(it) = sqrt(mean(InternalNT4LStep06(find(InternalNT4LStep06(:,4)==z),2))/pi);
    if sum(find(ind_ring06==z))>0
        Size_1(it) = NaN
    end
    it = it+1;
end
plot(linspace(0,1,length(slice_step06)), Size_1, '-o', 'markersize', 3);

Size_2 = zeros(length(slice_step13),1);
it = 1;
for z= slice_step13
    Size_2(it) = sqrt(mean(InternalNT4LStep13(find(InternalNT4LStep13(:,4)==z),2))/pi);
    if sum(find(ind_ring13==z))>0
        Size_2(it) = NaN;
    end
    it = it+1;
end
plot(linspace(0,1,length(slice_step13)), Size_2, '-o', 'markersize', 3);
% 
% 
ylabel('Size R_{eq}');


Eps_average = log([641 860 937]/641); % directly given by the height of the CT volume

figure; hold on;
plot(Eps_average, [nanmean(Size_0) nanmean(Size_1) nanmean(Size_2)], '-o', 'markersize', 3);
plot(Eps_average, [max(Size_0) max(Size_1) max(Size_2)], '-o', 'markersize', 3);
plot(Eps_average, [mean((Stat3D_NT4_L_01(:,1)/(4*pi/3)).^(1/3)) mean((Stat3D_NT4_L_06(:,1)/(4*pi/3)).^(1/3)) mean((Stat3D_NT4_L_13(:,1)/(4*pi/3)).^(1/3))], '-o', 'markersize', 3);
xlabel('\epsilon_{Loc}');
ylabel('Size R_{eq}');


figure; hold on;
delta = 10;
EpsLoc_0 =zeros(size(Size_0((ind_min0-delta):(ind_min0+delta))))
plot(EpsLoc_0, Size_0((ind_min0-delta):(ind_min0+delta)), 'o', 'markersize', 3);
EpsLoc_1 = 2*log(sqrt(ExternalNT4LStep01((ind_min0-delta):(ind_min0+delta),2)/pi)./sqrt(ExternalNT4LStep06((ind_min1-delta):(ind_min1+delta),2)/pi));
EpsLoc_2 = 2*log(sqrt(ExternalNT4LStep01((ind_min0-delta):(ind_min0+delta),2)/pi)./sqrt(ExternalNT4LStep13((ind_min2-delta):(ind_min2+delta),2)/pi));
plot(EpsLoc_1, Size_1((ind_min1-delta):(ind_min1+delta)), 'o', 'markersize', 3);
plot(EpsLoc_2, Size_2((ind_min2-delta):(ind_min2+delta)),'o', 'markersize', 3);
plot([0  mean(EpsLoc_1) mean(EpsLoc_2)], [nanmean(Size_0((ind_min0-delta):(ind_min0+delta)))  nanmean(Size_1((ind_min1-delta):(ind_min1+delta))) nanmean(Size_2((ind_min2-delta):(ind_min2+delta)))], '-ok'); 
xlabel('\epsilon_{Loc}');
ylabel('Size R_{eq}');


N_tracking = 20;
figure; hold on;
plot(Eps_average, [max(Size_0) max(Size_1) max(Size_2)], '-o', 'markersize', 3);
Size_3D_01 = ((Stat3D_NT4_L_01(:,1)/(4*pi/3)).^(1/3));
Size_3D_01_sorted = sort(Size_3D_01, 'descend');
Size_3D_06 = ((Stat3D_NT4_L_06(:,1)/(4*pi/3)).^(1/3));
Size_3D_06_sorted = sort(Size_3D_06, 'descend');
Size_3D_13 = ((Stat3D_NT4_L_13(:,1)/(4*pi/3)).^(1/3));
Size_3D_13_sorted = sort(Size_3D_13, 'descend');
plot(Eps_average, [mean(Size_3D_01_sorted(1:N_tracking)) mean(Size_3D_06_sorted(1:N_tracking)) mean(Size_3D_13_sorted(1:N_tracking))], '-o', 'markersize', 3);
xlabel('\epsilon_{Loc}');
ylabel('Equivalent radius R_{eq}');
legend('Average of [R_{eq}^{2D}]', '[R_{eq}^{3D}]');

N_tracking = 20;
figure; hold on;
Size_3D_01 = ((Stat3D_NT4_L_01(:,1)/(4*pi/3)).^(1/3));
Size_3D_01_sorted = sort(Size_3D_01, 'descend');
Size_3D_06 = ((Stat3D_NT4_L_06(:,1)/(4*pi/3)).^(1/3));
Size_3D_06_sorted = sort(Size_3D_06, 'descend');
Size_3D_13 = ((Stat3D_NT4_L_13(:,1)/(4*pi/3)).^(1/3));
Size_3D_13_sorted = sort(Size_3D_13, 'descend');
plot(Size_3D_01_sorted(1:N_tracking), '-o', 'markersize', 3);
plot(Size_3D_06_sorted(1:N_tracking), '-o', 'markersize', 3);
plot(Size_3D_13_sorted(1:N_tracking), '-o', 'markersize', 3);
xlabel('Largest voids tracked');
ylabel('Size R_{eq}');





