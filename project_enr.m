clear
clc

data = load("positionAndSpeeds_training_950.mat");
positionAndSpeeds_training = data.positionAndSpeeds_training;
data = load("firingrates_training_950.mat");
firingrates_training = data.firingrates_training;
data = load("positionAndSpeeds_testing_950.mat");
positionAndSpeeds_testing = data.positionAndSpeeds_testing;
data = load("firingrates_testing_950.mat");
firingrates_testing = data.firingrates_testing;

%disp("Calculating LASSO...")
%disp("xpos")
%[B1 STATS1] = lasso(firingrates_training, positionAndSpeeds_training(:,1),'Alpha',.5);
%disp("ypos")
%[B2 STATS2] = lasso(firingrates_training, positionAndSpeeds_training(:,2),'Alpha',.5);
%disp("xvel")
%[B3 STATS3] = lasso(firingrates_training, positionAndSpeeds_training(:,3),'Alpha',.5);
%disp("yvel")
%[B4 STATS4] = lasso(firingrates_training, positionAndSpeeds_training(:,4),'Alpha',.5);
%B = [B1 B2 B3 B4];
%save('B_fromLASSO.mat','B');
%disp("Calculation Done.")

B = load("B_fromLASSO.mat").B;
positionAndSpeeds_prediction = firingrates_testing*B;

corr_ = [];
for i=1:100
    corr_xpos = corr2(positionAndSpeeds_prediction(:,i), positionAndSpeeds_testing(:,1));
    corr_ypos = corr2(positionAndSpeeds_prediction(:,100+i), positionAndSpeeds_testing(:,2));
    corr_xvel = corr2(positionAndSpeeds_prediction(:,200+i), positionAndSpeeds_testing(:,3));
    corr_yvel = corr2(positionAndSpeeds_prediction(:,300+i), positionAndSpeeds_testing(:,4));
    corr_all = [corr_xpos; corr_ypos; corr_xvel; corr_yvel];
    corr_ = [corr_ corr_all];
end

f = figure;
hold on
subplot(2,2,1);
plot((0.001:0.001:0.05), corr_(1,1:50));
title('X position');
subplot(2,2,2);
plot((0.001:0.001:0.05), corr_(2,1:50));
title('Y position');
subplot(2,2,3);
plot((0.001:0.001:0.05), corr_(3,1:50));
title('X velocity');
subplot(2,2,4);
plot((0.001:0.001:0.05), corr_(4,1:50));
title('Y velocity');
hold off
saveas_ = '../figures/enr_lambdaToCorr';
savefig(append(saveas_, '.fig'));
saveas(f, append(saveas_, '.jpg'));

%corr = corr2(positionAndSpeeds_prediction, positionAndSpeeds_testing);
corr_xpos = corr2(positionAndSpeeds_prediction(:,1), positionAndSpeeds_testing(:,1));
corr_ypos = corr2(positionAndSpeeds_prediction(:,101), positionAndSpeeds_testing(:,2));
corr_xvel = corr2(positionAndSpeeds_prediction(:,201), positionAndSpeeds_testing(:,3));
corr_yvel = corr2(positionAndSpeeds_prediction(:,301), positionAndSpeeds_testing(:,4));

%mse = immse(positionAndSpeeds_prediction, positionAndSpeeds_testing);
mse_xpos = immse(positionAndSpeeds_prediction(:,1), positionAndSpeeds_testing(:,1));
mse_ypos = immse(positionAndSpeeds_prediction(:,101), positionAndSpeeds_testing(:,2));
mse_xvel = immse(positionAndSpeeds_prediction(:,201), positionAndSpeeds_testing(:,3));
mse_yvel = immse(positionAndSpeeds_prediction(:,301), positionAndSpeeds_testing(:,4));

f = figure;
hold on
scatter(positionAndSpeeds_testing(1:500,1),positionAndSpeeds_prediction(1:500,1))
plot(positionAndSpeeds_testing(1:500,1),positionAndSpeeds_testing(1:500,1))
xlabel('Actual X Position')
ylabel('Predicted X Position')
legend('Predicted Positions', 'Line of Perfect Fit')
hold off
saveas_ = '../figures/enr_PredActu';
savefig(append(saveas_, '.fig'));
saveas(f, append(saveas_, '.jpg'));

f = figure;
subplot(2,1,1)
hold on
plot(positionAndSpeeds_prediction(1:500,1))
plot(positionAndSpeeds_testing(1:500,1))
hold off
legend('predicted position', 'actual position')
%xlabel('sample #')
ylabel('X position')
subplot(2,1,2)
hold on
plot(positionAndSpeeds_prediction(1:500,101))
plot(positionAndSpeeds_testing(1:500,2))
hold off
legend('predicted position', 'actual position')
xlabel('sample # (100 ms bins)')
ylabel('Y position')
saveas_ = '../figures/enr_Pred';
savefig(append(saveas_, '.fig'));
saveas(f, append(saveas_, '.jpg'));