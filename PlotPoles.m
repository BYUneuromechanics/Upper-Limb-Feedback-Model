GTO = 1;
c_max = 0.5*1.1175*1.0099*1.001*1.000064;
c = 0.75*c_max;

sys_open = Full_Model(1,0,0,0,0);
[sys_closed,sys_rlocus] = Full_Model(1,c,0.1*c,GTO,1);

p_open = pole(sys_open);
p_closed = pole(pade(sys_closed));
z_open = zero(sys_open);
z_closed = zero(pade(sys_closed));

figure(1); clf
% tl = tiledlayout(1,2);
% ax_open = nexttile();
% ax_closed = nexttile();


% figure(1); clf
ax_open = subplot(1,2,1);
h_open = pzplot(ax_open,sys_open);
grid on
title('A) open-loop system')
xlim([-599,0])
ylim([-100,100])

% figure(2); clf
ax_closed = subplot(1,2,2);
h_closed = pzplot(ax_closed, pade(sys_closed));
grid on
title('B) closed-loop system')
xlim([-599,0])
ylim([-100,100])

sgtitle("Pole-Zero Plots")