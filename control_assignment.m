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
final_X1 = feedback(sys8, sys6 , +1);
X1_over_u = minreal(final_X1);
X1_over_u = -1 * X1_over_u;   % QUESTION: WHY !!!!!!!!!!
%%%%%%%%%% X2 %%%%%%%%%
sys9 = series(sys3, g6);
sys10 = series(sys9, sys6);
final_X2 = feedback(g1, sys10, +1);
X2_over_u = minreal(final_X2);
X2_over_u = -1 * X2_over_u;   % QUESTION: WHY !!!!!!!!!!
%%%%%%%%% req3 : check stability %%%%%%%%%%%
X1_poles = real(pole(X1_over_u));
X2_poles = real(pole(X2_over_u));

flag_x1 = 0;
%%%%%%%%% check stability for X1 %%%%%%%%%%%
for i = 1:size(X1_poles)
    if(X1_poles(i) >= 0)
        flag_x1 = 1;
        break;
    end
end
%%%%%%%%% check stability for X2 %%%%%%%%%%%
flag_x2 = 0;
for i = 1:size(X2_poles)
    if(X1_poles(i) >= 0)
        flag_x2 = 1;
        break;
    end
end

if(flag_x1 == 0 && flag_x2 == 0)
    disp('System is stable.');
else
disp('System is not stable.');
end

%figure(1)
pzmap(X1_over_u);
%[wn1,z1] = damp(X1_over_u);

figure(2)
pzmap(X2_over_u);
%[wn2,z2] = damp(X2_over_u);

%%%%%%%%%%%%%% req4: Simulation for input %%%%%%%%%%%%%%%%%
figure(3)
t = 0:220;      % Define a time vector

p1=stepplot(X1_over_u, t);
setoptions(p1,'RiseTimeLimits',[0,1]);
figure(4)
p2=stepplot(X2_over_u, t);
setoptions(p2,'RiseTimeLimits',[0,1]);
% QUESTION: Do we need to draw the two TF once, or separated ?
info1 = stepinfo(X1_over_u);
info2 = stepinfo(X2_over_u);
fprintf('Info 1:');
disp(info1)
fprintf('Info 2:');
disp(info2)

% Steady State error
[y,t] = step(X1_over_u);
sserror1 = abs(1- y(end)); %get the steady state error
fprintf('Steady State error X1: %.3f\n', sserror1);
[y2,t2] = step(X2_over_u);
sserror2 = abs(1- y2(end)); %get the steady state error
fprintf('Steady State error X2: %.3f\n', sserror2);

%%%%%%%%%%%%%% req 5,6,7 %%%%%%%%%%%%%%%%%
u  = tf(-1, 1);
branch_1 = series(final_X2, u);
result = feedback(branch_1, 1);
result_tf = minreal(result);




figure(5);
opt=stepDataOptions('InputOffset',0,'StepAmplitude',2);
p3=stepplot(result_tf, opt);
setoptions(p3,'RiseTimeLimits',[0,1]);



% Info
info3 = stepinfo(result_tf);
fprintf('Info 3:');
disp(info3);

% Steady State error
[y,t] = step(result_tf);
sserror1 = abs(1- y(end)); %get the steady state error
fprintf('Steady State error %.3f\n', sserror1);


