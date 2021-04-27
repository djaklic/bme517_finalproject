clear
clc

data = load("spikes.mat");
spikes = data.spikes;
test_number = 5;

% normalize
spikes_mean = mean(spikes);
spikes_normalized = spikes - spikes_mean;
s = std(spikes);
spikes_normalized = spikes_normalized ./s;

% pca
[CO, SCORE, LATENT] = pca(spikes_normalized);
co_2 = CO(:,1:2);
score_2 = SCORE(:,1:2);

k = 4;
[IDX, C, SUMD, D] = kmeans(score_2,k);

figure;
hold on
for i=1:k   
    plot(score_2(IDX==i,1),score_2(IDX==i,2), '.', 'MarkerSize',12)
end
plot(C(:,1),C(:,2),'kx', 'MarkerSize',15,'LineWidth',3) 
%legend('Cluster 1','Cluster 2','Cluster 3','Centroids', 'Location','NW')
title 'K-Means'
hold off

colors = ['r' 'b' 'g' 'y' 'p' 'o'];
figure;
hold on;
for i=1:k   
    a = spikes(IDX==i,:);
    a_mean = mean(a);
    a_std = std(a);
    %plot(a_mean)
    shadedErrorBar([],a_mean,a_std,'lineprops',colors(i));
end

hold off;

% advantages - probably faster if data sorted
[IDX2, C2, SUMD2, D2] = kmedoids(score_2,k);

figure;
hold on
for i=1:k   
    plot(score_2(IDX2==i,1),score_2(IDX2==i,2), '.', 'MarkerSize',12)
end
plot(C2(:,1),C2(:,2),'kx', 'MarkerSize',15,'LineWidth',3) 
%legend('Cluster 1','Cluster 2','Cluster 3','Centroids', 'Location','NW')
title 'K-Medoids'
hold off

figure;
hold on;
for i=1:k   
    a = spikes(IDX2==i,:);
    a_mean = mean(a);
    a_std = std(a);
    %plot(a_mean)
    shadedErrorBar([],a_mean,a_std,'lineprops',colors(i));
end
hold off;

% Mahalanobis distance kmeans
