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


B = load("B_fromLASSO_lambda.mat").B;
positionAndSpeeds_prediction = firingrates_testing*B;

%corr = corr2(positionAndSpeeds_prediction, positionAndSpeeds_testing);
corr_xpos = corr2(positionAndSpeeds_prediction(:,1), positionAndSpeeds_testing(:,1));
corr_ypos = corr2(positionAndSpeeds_prediction(:,2), positionAndSpeeds_testing(:,2));
corr_xvel = corr2(positionAndSpeeds_prediction(:,3), positionAndSpeeds_testing(:,3));
corr_yvel = corr2(positionAndSpeeds_prediction(:,4), positionAndSpeeds_testing(:,4));

%mse = immse(positionAndSpeeds_prediction, positionAndSpeeds_testing);
mse_xpos = immse(positionAndSpeeds_prediction(:,1), positionAndSpeeds_testing(:,1));
mse_ypos = immse(positionAndSpeeds_prediction(:,2), positionAndSpeeds_testing(:,2));
mse_xvel = immse(positionAndSpeeds_prediction(:,3), positionAndSpeeds_testing(:,3));
mse_yvel = immse(positionAndSpeeds_prediction(:,4), positionAndSpeeds_testing(:,4));

figure;
hold on
scatter(positionAndSpeeds_testing(1:500,1),positionAndSpeeds_prediction(1:500,1))
plot(positionAndSpeeds_testing(1:500,1),positionAndSpeeds_testing(1:500,1))
xlabel('Actual')
ylabel('Predicted')
hold off

figure;
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
plot(positionAndSpeeds_prediction(1:500,2))
plot(positionAndSpeeds_testing(1:500,2))
hold off
legend('predicted position', 'actual position')
xlabel('sample # (100 ms bins)')
ylabel('Y position')