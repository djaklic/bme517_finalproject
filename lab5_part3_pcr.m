clear
clc

data = load("spikes.mat");
spikes = data.spikes;
test_number = 5;

%figure;
%plot(spikes(test_number,:));
%xlabel('Sample # (10 kHz sampling)')
%ylabel('Recorded Voltage (uV)')

% don't use normalize()!
spikes_mean = mean(spikes);
spikes_normalized = spikes - spikes_mean;
s = std(spikes);
spikes_normalized = spikes_normalized ./s;

%figure;
%plot(spikes_normalized(test_number,:));

% coeff, score, latent
% U, W(Z), L
% eigenvecs, weights, eigenvals
% SCORE are corresponding 'x' coords in 'z' space
[CO, SCORE, LATENT] = pca(spikes_normalized);

co_2 = CO(:,1:2);
score_2 = SCORE(:,1:2);

spikes_pcr = spikes_normalized;%(test_number,:);
mean_spikes_pcr = mean(spikes_pcr);
y = (spikes_pcr-mean_spikes_pcr);
X = score_2;%(test_number,:)';
%b_pcr = regress(, );

% 9 dimensions needed
k = 9;

