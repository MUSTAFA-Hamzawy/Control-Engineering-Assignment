%%%%%%  Input the blocks %%%%%%%%
g1=tf(1, 50);
g2=tf(50, 1);
g3=tf(5, 1);
g4=tf([100 0], 1);
g5=tf([100 0 0], 1);
g6=tf(1, 50);
g7=tf(5, 1);
g8=tf([100 0], 1);
g9=tf(50, 1);
g10=tf([100 0 0], 1);

%%%%%%  Connecting the blocks %%%%%%%%
% T2 %
sys1 = parallel(g2, g3);
sys2 = parallel(sys1, g4);
sys3 = parallel(sys2, g5);

% T1 %
sys4 = parallel(g7, g8);
sys5 = parallel(sys4, g9);
sys6 = parallel(sys5, g10);

sys7 = series(g1, sys3);
sys8 = series(sys7, g6);

%%%%%%%%%% X1 %%%%%%%%%
final_X1 = feedback(sys8, sys6);
X1_over_u = minreal(final_X1);

%%%%%%%%%% X2 %%%%%%%%%
sys9 = series(sys3, g6);
sys10 = series(sys9, sys6);
final_X2 = feedback(g1, sys10);
X2_over_u = minreal(final_X2);
