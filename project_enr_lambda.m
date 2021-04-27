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


%lambda = 0.02143;
%disp("Calculating LASSO...")
%disp("xpos")
%[B1 STATS1] = lasso(firingrates_training, positionAndSpeeds_training(:,1), 'Lambda', lambda,'Alpha',.5);
%disp("ypos")
%[B2 STATS2] = lasso(firingrates_training, positionAndSpeeds_training(:,2), 'Lambda', lambda,'Alpha',.5);
%disp("xvel")
%[B3 STATS3] = lasso(firingrates_training, positionAndSpeeds_training(:,3), 'Lambda', lambda,'Alpha',.5);
%disp("yvel")
%[B4 STATS4] = lasso(firingrates_training, positionAndSpeeds_training(:,4), 'Lambda', lambda,'Alpha',.5);
%B = [B1 B2 B3 B4];
%save('B_fromLASSO_lambda.mat','B');
%disp("Calculation Done.")

