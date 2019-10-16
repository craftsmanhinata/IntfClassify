acc5bk = load('trainAcc_05bk.mat');
acc5bk = acc5bk.trainAcc;
acc2k = load('trainAcc_2k.mat');
acc2k = acc2k.trainAcc;
acc05k = load('trainAcc_05k.mat');
acc05k = acc05k.trainAcc;
figure;
plot(acc5bk(1:40),'LineWidth',1);
hold on;
plot(acc2k(1:40),'--','LineWidth',1);
hold on;
plot(acc05k(1:40),'-.','LineWidth',1);
% legend('5k','2k','0.5k')
% legend('2k','0.5k','5k')
grid on;


% legend('N 500','N 2000', 'N 2000 downsample')
legend('L 2000','L 2000 downsample','L 500')
xlabel('iterations');
ylabel('training accuracy');
grid on;

title('training accuracy over iterations')