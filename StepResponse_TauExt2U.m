posture = 1;

delay_multiplier = 1;

muscle_names = {'Delt Ant';'Delt Lat';'Delt Post';'Pec Maj';'Bi Long';'Bi Short';'Tri Long';'Tri Lat';'Bra';'Brd';'PT';'ECR';'ECU';'FCR';'FCU'};
DOF_names = {'SFE';'SAA';'SIER';'EFE';'FPS';'WFE';'WRUD'};

t = 0:0.001:2;

P_0 = 0;
P_25 = 0.141220514190756;
P_50 = P_25*2;
P_75 = P_25*3;
GTO_0 = 0;
GTO_25 = 2.7/1.27*0.25;
GTO_50 = 2.7/1.27*0.50;
GTO_75 = 2.7/1.27*0.75;

% sys_spindleGain_gto_gain expressed as percent of maximum
sys_0_0 = tau_ext2muscle_activity(posture,P_0,P_0*0.1,GTO_0,delay_multiplier);
sys_25_25 = tau_ext2muscle_activity(posture,P_25,P_25*0.1,GTO_25,delay_multiplier);
sys_50_25 = tau_ext2muscle_activity(posture,P_50,P_50*0.1,GTO_25,delay_multiplier);
sys_75_25 = tau_ext2muscle_activity(posture,P_75,P_75*0.1,GTO_25,delay_multiplier);
sys_25_50 = tau_ext2muscle_activity(posture,P_25,P_25*0.1,GTO_50,delay_multiplier);
sys_25_75 = tau_ext2muscle_activity(posture,P_25,P_25*0.1,GTO_75,delay_multiplier);
sys_50_50 = tau_ext2muscle_activity(posture,P_50,P_50*0.1,GTO_50,delay_multiplier);

y_0_0 = step(sys_0_0,t);
y_25_25 = step(sys_25_25,t);
y_50_25 = step(sys_50_25,t);
y_75_25 = step(sys_75_25,t);
y_25_50 = step(sys_25_50,t);
y_25_75 = step(sys_25_75,t);
y_50_50 = step(sys_50_50,t);

y_min = min(min(min([y_0_0,y_25_25,y_50_25,y_75_25,y_25_50,y_25_75,y_50_50])));
y_max = max(max(max([y_0_0,y_25_25,y_50_25,y_75_25,y_25_50,y_25_75,y_50_50])));

%% Plot Results
y_min = -0.01;
y_max =  0.01;

figure(1); clf
TL_Parent = tiledlayout(2,1,"TileSpacing","compact");
ax1 = nexttile(TL_Parent,1);
set(gca,'XTick',[],'YTick',[])

% TOP SUBPLOT
TL = tiledlayout(TL_Parent,7,15,"TileSpacing","none");
TL.Layout.Tile = 1;
TL.Layout.TileSpan = [1 1];
for i = 1:7
   for o=1:15
        nexttile(TL)
        plot(t,y_0_0(:,o,i),'Color',[0.5,0.5,0.5],'LineWidth',1.3)
        hold on
        plot(t,y_25_25(:,o,i))
        plot(t,y_50_25(:,o,i))
        plot(t,y_75_25(:,o,i))
        plot(t,y_25_50(:,o,i))
        plot(t,y_25_75(:,o,i))
        plot(t,y_50_50(:,o,i))
        
        ylim([y_min,y_max])
        yticks([])
        % if o == 1
        %     ylabel(DOF_names(i))
        % end
        if o == 15
            % yticks('auto')
            ylabel(DOF_names(i))
            set(gca, 'YAxisLocation', 'right');
        end
        xticks([])
        if i == 1
            xlabel(muscle_names(o),'Rotation',45)
            set(gca,'XAxisLocation','top');
        end
        % if i == 7
        %     xticks('auto')
        % end
    end
end

xlabel(TL,sprintf('Time (0-%ds)',t(end)))
ylabel(TL,'Muscle Activity, \bf{}\it{}u\rm{} (-1 to 1 MVC)')
% L = legend({'no feedback'; 'S:25%, G:25%';'S:50%, G:25%';'S:75%, G:25%';'S:25%, G:50%';'S:25%, G75%'; 'S:50%, G:50%'},"Orientation","horizontal");
% L.ItemTokenSize(1) = 15;
%title(ax1,"A");
%ax1.TitleHorizontalAlignment = 'left';

% BOTTOM SUBPLOT
ax2 = nexttile(TL_Parent,2);
set(gca,'XTick',[],'YTick',[])
TL = tiledlayout(TL_Parent,7,15,"TileSpacing","none");
TL.Layout.Tile = 2;
TL.Layout.TileSpan = [1 1];
for i = 1:7
   for o=1:15
        nexttile(TL)
        plot(t,y_0_0(:,o,i),'Color',[0.5,0.5,0.5],'LineWidth',1.3)
        hold on
        plot(t,y_25_25(:,o,i))
        plot(t,y_50_25(:,o,i))
        plot(t,y_75_25(:,o,i))
        plot(t,y_25_50(:,o,i))
        plot(t,y_25_75(:,o,i))
        plot(t,y_50_50(:,o,i))
        
        %ylim([q_min,q_max])
        yticks([])
        % if o == 1
        %     ylabel(DOF_names(i))
        % end
        xlim([0,0.1])
        if o == 15
            % yticks('auto')
            ylabel(DOF_names(i))
            set(gca, 'YAxisLocation', 'right');
        end
        xticks([])
        % if i == 1
        %     xlabel(muscle_names(o))
        %     set(gca,'XAxisLocation','top');
        % end
        % if i == 7
        %     xticks('auto')
        % end
    end
end

%title(ax2,"B");
%ax2.TitleHorizontalAlignment = 'left';
xlabel(TL,'Time (0-0.1s)')
ylabel(TL,'Muscle Activity, \bf{}\it{}u')
L = legend({'no feedback'; 'S:25%, G:25%';'S:50%, G:25%';'S:75%, G:25%';'S:25%, G:50%';'S:25%, G75%'; 'S:50%, G:50%'},"Orientation","horizontal");
L.ItemTokenSize(1) = 10;

title(TL_Parent,{'Step Response: Input in \bf{}\it{}\tau_e_x_t\rm{} , Output in \bf{}\it{}u',' '})
%%
S_0_0 = stepinfo(sys_0_0);
S_50_50 = stepinfo(sys_50_50);

R_set_time = NaN(7,7);
R_peak_time = NaN(7,7);
for o = 1:7
    for i = 1:7
        R_set_time(o,i) = S_50_50(o,i).SettlingTime / S_0_0(o,i).SettlingTime;
        R_peak_time(o,i) = S_50_50(o,i).PeakTime / S_0_0(o,i).PeakTime;
    end
end

figure(8)
imagesc(R_set_time)
colorbar()
xticklabels(DOF_names); yticklabels(DOF_names)
title('Multiplicative Increase in Settling Time: (S:50%, G:50%)/No Feedback')
xlabel('Step in External Torque')
ylabel('Output in DOF')

figure(9)
imagesc(R_peak_time)
colorbar()
xticklabels(DOF_names); yticklabels(DOF_names)
title('Multaplicative Increase in Peak Time: (S:50%, G:50%)/No Feedback')
xlabel('Step in External Torque')
ylabel('Output in DOF')