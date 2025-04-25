muscles = {'Delt Ant';'Delt Lat';'Delt Post';'Pec Maj';'Bi Long';'Bi Short';'Tri Long';'Tri Lat';'Bra';'Brd';'PT';'ECR';'ECU';'FCR';'FCU'};
DOFs = {'SFE';'SAA';'SIER';'EFE';'FPS';'WFE';'WRUD'};

c_max = 0.5*1.1175*1.0099*1.001*1.000064;
w = 0:0.1:2*pi*12;

for m = [0,0.25,0.5,0.75] % m stands for 'multiplier'
    m_ID = "pct_"+num2str(m*100);
    c = m*c_max;

    for GTO=[0,1]
        if GTO
            GTO_ID = 'ON';
        else
            GTO_ID = 'OFF';
        end
        
        sys = Full_Model(1,c,0.1*c,GTO,1);
        [mag.(m_ID).(GTO_ID),phase.(m_ID).(GTO_ID)] = bode(sys,w);
    end
end


mag_max = findHighestValueInStruct(mag);
%%
%PLOT THE RESULTS
figure(1); clf

TL_Parent = tiledlayout(1,2,"TileSpacing","compact");
ax1 = nexttile(TL_Parent,1);
set(gca,'XTick',[],'YTick',[])


% LEFT SUBPLOT
TL = tiledlayout(TL_Parent,15,7,'TileSpacing','none');
TL.Layout.Tile = 1;
TL.Layout.TileSpan = [1 1];
for i = 1:15
    muscle = muscles{i};

    for o = 1:7
        DOF = DOFs{o};
        nexttile(TL)

        for m = [0,0.25,0.5,0.75]
            m_ID = "pct_" + num2str(m*100);

            for GTO = [0,1]
                if GTO
                    GTO_ID = 'ON';
                else
                    GTO_ID = 'OFF';
                end
                mag_ratios = squeeze(mag.(m_ID).(GTO_ID)(o,i,:));
                if m==0 && GTO==0
                    plot(w/(2*pi),mag_ratios, 'k')
                    hold on
                else
                    plot(w/(2*pi),mag_ratios)
                end
                
                % title(muscle + ' ' + DOF) % Make sure muscles are rows and DOF are columns
                xticks([]); yticks([])
                if strcmp(DOF,DOFs{7})
                    ylabel(muscle, "rotation", 0)
                    set(gca,'YAxisLocation','right')
                end
                if strcmp(muscle,muscles{1})
                    xlabel(DOF)
                    set(gca,'XAxisLocation','top')
                end
            end
        end
        ylim([0,40])
    end
end
xlabel(TL,'Frequency (0-12Hz)')
ylabel(TL,'Magnitude Ratio (0 to 40 rad/MVC)')
lgd = legend({'0% c_m_a_x', '', '25% c_m_a_x', '', '50% c_m_a_x', '', '75% c_m_a_x', ''},'Orientation','horizontal','Location','southoutside');
lgd.ItemTokenSize(1) = 15;
lgd.Position = [0.4, 0.04, 0.35, 0.02];
a1 = annotation('textbox',[0.3,0,0.1,0.1],'String',"with GTO",'FitBoxToText','on','EdgeColor','none');
% title(ax1,"A")
% ax1.TitleHorizontalAlignment = 'left';

% RIGHT SUBPLOT
ax2 = nexttile(TL_Parent,2);
set(gca,'XTick',[],'YTick',[])
TL = tiledlayout(TL_Parent,15,7,"TileSpacing","none");
TL.Layout.Tile = 2;
TL.Layout.TileSpan = [1 1];
for i = 1:15
    muscle = muscles{i};

    for o = 1:7
        DOF = DOFs{o};
        nexttile(TL)

        for m = [0,0.25,0.5,0.75]
            m_ID = "pct_" + num2str(m*100);

            for GTO = [0,1]
                if GTO
                    GTO_ID = 'ON';
                else
                    GTO_ID = 'OFF';
                end
                mag_ratios = squeeze(mag.(m_ID).(GTO_ID)(o,i,:));
                if m==0 && GTO==0
                    plot(w/(2*pi),mag_ratios, 'k')
                    hold on
                else
                    plot(w/(2*pi),mag_ratios)
                end
                % title(muscle + ' ' + DOF) % Make sure muscles are rows and DOF are columns
                % nexttile() traverses a row before moving to the next row.
                xticks([]); yticks([])
                % if strcmp(DOF,DOFs{1})
                %     ylabel(muscle, "rotation", 0)
                % end
                if strcmp(muscle,muscles{1})
                    xlabel(DOF)
                    set(gca,'XAxisLocation','top');
                end
            end
        end
    end
end
xlabel(TL,'Frequency (0-12Hz)')
ylabel(TL,'Magnitude Ratio')
nexttile((15-1)*7 + 1); % Go to the 15th row 1st column for the legend
lgd = legend({'', '0% c_m_a_x', '', '25% c_m_a_x', '', '50% c_m_a_x', '', '75% c_m_a_x'},'Orientation','horizontal','Location','southoutside');
lgd.ItemTokenSize(1) = 15;
lgd.Position = [0.4, 0.02, 0.35, 0.02];
a2 = annotation('textbox',[0.3,0,0.0,0.1],'String',"without GTO",'FitBoxToText','on','EdgeColor','none');
% title(ax2,"B")
% ax2.TitleHorizontalAlignment = 'left';

title(TL_Parent, {"Frequency Response: Input in \bf{}\it{}u_C_N_S\rm{}, Output in \bf{}\it{}q",' '})




% FIND MAX VALUE IN STRUCT
function maxValue = findHighestValueInStruct(mags)
    maxValue = nan; % Initialize max value
    
    fields = fieldnames(mags); % Get all field names
    for i = 1:numel(fields)
        fieldValue = mags.(fields{i}); % Extract the field value
        
        if isstruct(fieldValue) % If the field is a nested struct
            nestedMax = findHighestValueInStruct(fieldValue); % Recursive call
            maxValue = max(maxValue, nestedMax); % Update max value
        elseif isnumeric(fieldValue) % If the field is numeric
            maxValue = max(maxValue, max(fieldValue(:))); % Find max in numeric array
        end
    end
end
