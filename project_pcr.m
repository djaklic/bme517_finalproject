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


fr_mean = mean(firingrates_training);
fr_normalized = firingrates_training - fr_mean;
%s = std(firingrates_training);
%fr_normalized = fr_normalized ./s;

[CO, SCORE, LATENT] = pca(fr_normalized);
[n,p] = size(fr_normalized);

f = figure;
scatter(SCORE(:,1), SCORE(:,2), '.');
xlabel({'','Principle Component 1'});
ylabel({'','Principle Component 2'});
saveas_ = '../figures/pcr_pc1vspc2';
savefig(append(saveas_, '.fig'));
saveas(f, append(saveas_, '.jpg'));

weight = cumsum(LATENT);
weight_total = sum(LATENT);

B_full = inv(firingrates_training'*firingrates_training)*firingrates_training'*positionAndSpeeds_training;

B_PCR = inv(SCORE(:,1:22)'*SCORE(:,1:22))*SCORE(:,1:22)'*positionAndSpeeds_training;
B_PCR = CO(:,1:22)*B_PCR;
%B_PCR = [fr_mean - fr_mean*betaPCR; betaPCR];

positionAndSpeeds_prediction = firingrates_testing*B_PCR;

mse = immse(positionAndSpeeds_prediction, positionAndSpeeds_testing);
mse_xpos = immse(positionAndSpeeds_prediction(:,1), positionAndSpeeds_testing(:,1));
mse_ypos = immse(positionAndSpeeds_prediction(:,2), positionAndSpeeds_testing(:,2));
mse_xvel = immse(positionAndSpeeds_prediction(:,3), positionAndSpeeds_testing(:,3));
mse_yvel = immse(positionAndSpeeds_prediction(:,4), positionAndSpeeds_testing(:,4));

corr_total = corr2(positionAndSpeeds_prediction, positionAndSpeeds_testing);
corr_xpos = corr2(positionAndSpeeds_prediction(:,1), positionAndSpeeds_testing(:,1));
corr_ypos = corr2(positionAndSpeeds_prediction(:,2), positionAndSpeeds_testing(:,2));
corr_xvel = corr2(positionAndSpeeds_prediction(:,3), positionAndSpeeds_testing(:,3));
corr_yvel = corr2(positionAndSpeeds_prediction(:,4), positionAndSpeeds_testing(:,4));

%Variance
%22 PCSs= 50% variance
f = figure;
plot(weight/weight_total);
xlabel('Number of Principal Components');
ylabel('Percent Variance Accounted For');
%legend('PCR','location','SE');
saveas_ = '../figures/pcr_variance';
savefig(append(saveas_, '.fig'));
saveas(f, append(saveas_, '.jpg'));

%10-fold cross-validation
%figure;
%PCRmsep = sum(crossval(@pcrsse,fr_normalized(1:15706,:),positionAndSpeeds_testing(:,1),'KFold',950),1) / n;
%plot(0:10,PCRmsep);
%xlabel('Number of components');
%ylabel('Estimated Mean Squared Prediction Error');
%legend('PCR','location','NE');

%'Model Parsimony'
%Parsimonious models are simple models with great explanatory predictive power.
%They explain data with a minimum number of parameters, or predictor variables.
f = figure;
for i=1:5
    subplot(3,2,i);
    plot(CO(1:50,i));
    t = "Component " + string(i);
    title(t)
end
%[h, l] = figure.get_legend_handles_labels();
%xlabel('Variable');
%ylabel('PCA Loading');
%legend({'1st Component' '2nd Component'},'location','NW');
subplot(3,2,6);
plot(fr_normalized(1:50,5), 'r');
title("Rep. Sample");
saveas_ = '../figures/pcr_Parsimony';
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
plot(positionAndSpeeds_prediction(1:500,2))
plot(positionAndSpeeds_testing(1:500,2))
hold off
legend('predicted position', 'actual position')
xlabel('sample # (100 ms bins)')
ylabel('Y position')
saveas_ = '../figures/pcr_performance';
savefig(append(saveas_, '.fig'));
saveas(f, append(saveas_, '.jpg'));

