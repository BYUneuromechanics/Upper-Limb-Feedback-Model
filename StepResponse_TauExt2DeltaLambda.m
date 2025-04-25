posture = 1;
delay_multiplier = 1;

muscle_names = {'Delt Ant';'Delt Lat';'Delt Post';'Pec Maj';'Bi Long';'Bi Short';'Tri Long';'Tri Lat';'Bra';'Brd';'PT';'ECR';'ECU';'FCR';'FCU'};
DOF_names = {'SFE';'SAA';'SIER';'EFE';'FPS';'WFE';'WRUD'};

t = 0:0.001:4;

P_0     = 0;
P_25    = 0.141220514190756;
P_50    = P_25*2;
P_75    = P_25*3;
GTO_0   = 0;
GTO_25  = 2.7/1.27*0.25;
GTO_50  = 2.7/1.27*0.50;
GTO_75  = 2.7/1.27*0.75;

% sys_spindleGain_gto_gain expressed as percent of maximum
sys_0_0 =   sys_tauExt2DeltaLambda(posture,P_0, P_0*0.1, GTO_0, delay_multiplier);
sys_25_25 = sys_tauExt2DeltaLambda(posture,P_25,P_25*0.1,GTO_25,delay_multiplier);
sys_50_25 = sys_tauExt2DeltaLambda(posture,P_50,P_50*0.1,GTO_25,delay_multiplier);
sys_75_25 = sys_tauExt2DeltaLambda(posture,P_75,P_75*0.1,GTO_25,delay_multiplier);
sys_25_50 = sys_tauExt2DeltaLambda(posture,P_25,P_25*0.1,GTO_50,delay_multiplier);
sys_25_75 = sys_tauExt2DeltaLambda(posture,P_25,P_25*0.1,GTO_75,delay_multiplier);
sys_50_50 = sys_tauExt2DeltaLambda(posture,P_50,P_50*0.1,GTO_50,delay_multiplier);

y_0_0   = step(sys_0_0,t);
y_25_25 = step(sys_25_25,t);
y_50_25 = step(sys_50_25,t);
y_75_25 = step(sys_75_25,t);
y_25_50 = step(sys_25_50,t);
y_25_75 = step(sys_25_75,t);
y_50_50 = step(sys_50_50,t);

y_min = min(min(min([y_0_0(:,:,:),y_50_50(:,:,:),y_25_25(:,:,:),y_50_25(:,:,:),y_75_25(:,:,:),y_25_50(:,:,:),y_25_75(:,:,:)])))*1000;
y_max = max(max(max([y_0_0(:,:,:),y_50_50(:,:,:),y_25_25(:,:,:),y_50_25(:,:,:),y_75_25(:,:,:),y_25_50(:,:,:),y_25_75(:,:,:)])))*1000;

%% PLOT RESULTS
y_min =-25;
y_max = 25;

figure(1); clf;


TL_Parent = tiledlayout(1,2,"TileSpacing","compact");
ax1 = nexttile(TL_Parent,1);
set(gca,'XTick',[],'YTick',[])
TL = tiledlayout(TL_Parent,15,7,"TileSpacing","none");
TL.Layout.Tile = 1;
TL.Layout.TileSpan = [1 1];

% LEFT SUBPLOT
for o = 1:15
    for i = 1:7
        nexttile(TL)
        plot(t,y_0_0(:,o,i)*1000,'color',[0.5,0.5,0.5],'LineWidth',1.3)
        hold on
        plot(t,y_25_25(:,o,i)*1000)
        plot(t,y_50_25(:,o,i)*1000)
        plot(t,y_75_25(:,o,i)*1000)
        plot(t,y_25_50(:,o,i)*1000)
        plot(t,y_25_75(:,o,i)*1000)
        plot(t,y_50_50(:,o,i)*1000)
        
        ylim([y_min,y_max])
        yticks([])
        if i == 7
            ylabel(muscle_names(o),'Rotation',0)
            set(gca,'YAxisLocation','right')
        end
        % if i==1 && o==15
        %     yticks('auto')
        %     %set(gca, 'YAxisLocation', 'right');
        % end
        xticks([])
        if o == 1
            xlabel(DOF_names(i))
            set(gca,'XAxisLocation','top');
        end
        % if o == 15
        %     xticks('auto')
        % end
    end
end

ylabel(TL,'\bf{}\it{}\Delta\lambda\rm{} (-25 to 25 mm)')
xlabel(TL,"Time (0-4s)")
% title(ax1,"A")
% ax1.TitleHorizontalAlignment = 'left';

% RIGHT SUBPLOT
ax2 = nexttile(TL_Parent,2);
set(gca,'XTick',[],'YTick',[])
TL = tiledlayout(TL_Parent,15,7,"TileSpacing","none");
TL.Layout.Tile = 2;
TL.Layout.TileSpan = [1 1];
for o = 1:15
    for i = 1:7
        nexttile(TL)
        plot(t,y_0_0(:,o,i)*1000,'color',[0.5,0.5,0.5],'LineWidth',1.3)
        hold on
        plot(t,y_25_25(:,o,i)*1000)
        plot(t,y_50_25(:,o,i)*1000)
        plot(t,y_75_25(:,o,i)*1000)
        plot(t,y_25_50(:,o,i)*1000)
        plot(t,y_25_75(:,o,i)*1000)
        plot(t,y_50_50(:,o,i)*1000)
        
        % ylim([q_min,q_max])
        yticks([])
        % if i == 1
        %     ylabel(muscle_names(o),'Rotation',0)
        % end
        % if i == 7
        %     yticks('auto')
        %     set(gca, 'YAxisLocation', 'right');
        % end
        xlim([0,2])
        xticks([])
        if o == 1
            xlabel(DOF_names(i))
            set(gca,'XAxisLocation','top');
        end
        % if o == 15
        %     xticks('auto')
        % end
    end
end
% title(ax2,"B")
% ax2.TitleHorizontalAlignment = 'left';
xlabel(TL,'Time (0-2s)')
ylabel(TL,'\bf{}\it{}\Delta\lambda')
L = legend({'no feedback'; 'S:25%, G:25%';'S:50%, G:25%';'S:75%, G:25%';'S:25%, G:50%';'S:25%, G75%'; 'S:50%, G:50%'},'Orientation','horizontal');
L.ItemTokenSize(1) = 15;

title(TL_Parent,{'Step Response: Input in \bf{}\it{}\tau_e_x_t\rm{} , Output in \bf{}\it{}\Delta\lambda',' '})

%% Heatmaps of Settling Time and Peak Time
S_0_0 = stepinfo(sys_0_0);
S_50_50 = stepinfo(sys_50_50);

R_set_time = NaN(7,7);
R_peak_time = NaN(7,7);
R_overshoot = NaN(7,7);
for o = 1:7
    for i = 1:7
        R_set_time(o,i) = S_50_50(o,i).SettlingTime / S_0_0(o,i).SettlingTime;
        R_peak_time(o,i) = S_50_50(o,i).PeakTime / S_0_0(o,i).PeakTime;
        R_overshoot(o,i) = S_50_50(o,i).Overshoot / S_0_0(o,i).Overshoot;
    end
end

figure(8)
imagesc(R_set_time)
colorbar()
xticklabels(DOF_names); yticklabels(DOF_names)
title('Multiplicative Increase in Settling Time: (S:50%, G:50%)/No Feedback')
xlabel('Step in External Torque')
ylabel('Output in DeltaLambda')

figure(9)
imagesc(R_peak_time)
colorbar()
xticklabels(DOF_names); yticklabels(DOF_names)
title('Multaplicative Increase in Peak Time: (S:50%, G:50%)/No Feedback')
xlabel('Step in External Torque')
ylabel('Output in DeltaLambda')

figure(10)
imagesc(R_overshoot)
colorbar()
xticklabels(DOF_names); yticklabels(DOF_names)
title('Multaplicative Increase in Percent Overshoot: (S:50%, G:50%)/No Feedback')
xlabel('Step in External Torque')
ylabel('Output in DeltaLambda')

%% Steady State Resonse (DC Gain)
k0 = dcgain(sys_0_0);
k50 = dcgain(sys_50_50);

figure(11)
imagesc(k50./k0)
colorbar()
xticklabels(DOF_names); yticklabels(DOF_names)
title('Multaplicative Increase in DC Gain: (S:50%, G:50%)/No Feedback')
xlabel('External Torque')
ylabel('DeltaLambda')