clear
clc

data = load("spikes.mat");
spikes = data.spikes;
test_number = 5;

figure;
plot(spikes(test_number,:));
xlabel('Sample # (10 kHz sampling)')
ylabel('Recorded Voltage (uV)')

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

weight = cumsum(LATENT);
total_weight = (weight(length(weight)));
% 9 dimensions needed
k = 9;
labels = ['1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'; "NOS"];

figure;
subplot(1,2,1)
hold on
plot(CO(:,1:k));
plot(spikes_normalized(test_number,:));
leg = legend(labels);
leg.Location = 'northwest';
leg.NumColumns = 2;
leg.Color = 'none';
leg.EdgeColor = 'none';
xlabel('Sample # (10 kHz sampling)')
ylabel('Recorded Voltage (uV)')
hold off
subplot(1,2,2)
%title('a')
hold on
plot(CO(:,1:3));
leg = legend(labels(1:3,:));
leg.Location = 'northwest';
leg.NumColumns = 2;
leg.Color = 'none';
leg.EdgeColor = 'none';
xlabel('Sample # (10 kHz sampling)')
ylabel('Recorded Voltage (uV)')
hold off

%spike 5 w/ all PCA
recon = SCORE*CO';
recon_un_normal = recon.*s;
recon_un_normal = recon_un_normal + spikes_mean;
err = immse(recon_un_normal(test_number,:),spikes(test_number,:));
fprintf('%f\n', err)

%figure;
%hold on
%plot(recon(test_number,:));
%plot(spikes_normalized(test_number,:));
%title('normalized')
%legend('reconstruct', 'original')
%hold off

figure;
hold on
plot(recon_un_normal(test_number,:));
plot(spikes(test_number,:));
%title('un-normalized')
q = append('All PC MSE = ',num2str(err));
text(3,50,q);
leg = legend('Reconstructed Signal', 'Original Signal');
xlabel('Sample # (10 kHz sampling)')
ylabel('Recorded Voltage (uV)')
leg.Location = 'southeast';
leg.Color = 'none';
leg.EdgeColor = 'none';
hold off

figure;
hold on;

%spike 5 w/ 9 PCA
recon9 = SCORE(:,1:k)*CO(:,1:k)';
recon9 = recon9.*s;
recon9 = recon9 + spikes_mean;
err = immse(recon9(test_number,:),spikes(test_number,:));
fprintf('%f\n', err)
q = append('9PC MSE = ',num2str(err));
text(3,50,q);
plot(recon9(test_number,:));

%spike 5 w/ 6 PCA
recon6 = SCORE(:,1:6)*CO(:,1:6)';
recon6 = recon6.*s;
recon6 = recon6 + spikes_mean;
err = immse(recon6(test_number,:),spikes(test_number,:));
fprintf('%f\n', err)
q = append('6PC MSE = ',num2str(err));
text(3,40,q);
plot(recon6(test_number,:));

%spike 5 w/ 4 PCA
recon4 = SCORE(:,1:4)*CO(:,1:4)';
recon4 = recon4.*s;
recon4 = recon4 + spikes_mean;
err = immse(recon4(test_number,:),spikes(test_number,:));
fprintf('%f\n', err)
q = append('4PC MSE = ',num2str(err));
text(3,30,q);
plot(recon4(test_number,:));

plot(recon_un_normal(test_number,:));
%title('different PCA')
leg = legend('9 PCs', '6 PCs', '4 PCs', 'Original Signal');
leg.Location = 'southeast';
leg.Color = 'none';
leg.EdgeColor = 'none';
xlabel('Sample # (10 kHz sampling)')
ylabel('Recorded Voltage (uV)')
hold off

%figure;
%scatter(CO(:,1), CO(:,2))

%this is what you want
figure;
scatter(SCORE(:,1), SCORE(:,2), '.')
xlabel({'','Principle Component 1'})
ylabel({'','Principle Component 2'})


