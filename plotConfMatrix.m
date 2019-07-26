test = load('./data/Ytest3.mat');
Ytest = test.Ytest;
pred = load('./data/Ypred3.mat');
Ypred = pred.Ypred;
intfName = { 'awgn', 'tone', 'chirp', 'filtN','copyCat'};


Ypred = double(Ypred)';
Ytest = double(Ytest)';
N = length(Ypred);

figure;
clf



        
            

subplot(2,3,1)
Ypred = load('RNNraw_Ypred.mat');
Ypred = Ypred.Ypred;
Ytest = load('RNNraw_Ytest.mat');
Ytest = Ytest.Ytest;

plotConfMat(myCalConfusionMatrix(Ytest,Ypred), intfName);
title('Raw  + RNN');





% a = 0.01;
% for i = 1:N
%     if rand <  a 
%         if rand < 0.5
%             t = Ypred(i) + 1;
%         else
%             t = Ypred(i) - 1;
%         end
%         if  t < 1
%             Ypred(i) = 5;
%         elseif  t > 5
%             Ypred(i) = 1;
%         end
%     end
% end
subplot(2,3,2)
Ypred = load('alpha_Ypred.mat');
Ypred = Ypred.Ypred;
Ytest = load('alpha_Ytest.mat');
Ytest = Ytest.Ytest;
plotConfMat(myCalConfusionMatrix(Ytest,Ypred), intfName);
title('\alpha-profile + RNN');

subplot(2,3,3)
Ypred = load('RNN_Ypred.mat');
Ypred = Ypred.Ypred;
Ytest = load('RNN_Ytest.mat');
Ytest = Ytest.Ytest;
plotConfMat(myCalConfusionMatrix(Ytest,Ypred), intfName);
title('RNN');

subplot(2,3,4)
Ypred = load('DNN_Ypred.mat');
Ypred = Ypred.y_pred;
Ytest = load('DNN_Ytest.mat');
Ytest = Ytest.y_test;
plotConfMat(myCalConfusionMatrix(Ytest,Ypred), intfName);
title('DNN');

subplot(2,3,5)
Ypred = load('SVM_Ypred.mat');
Ypred = Ypred.Ypred;
Ytest = load('SVM_Ytest.mat');
Ytest = Ytest.Ytest;
plotConfMat(myCalConfusionMatrix(Ytest,Ypred), intfName);
title('SVM');

subplot(2,3,6)
str = {'Raw';'\alpha';'RNN';'DNN';'SVM'};
bar([0.60 0.23 0.96 0.82 0.67]);
set(gca, 'XTickLabel',str,'FontSize',6 ,'XTick',1:numel(str))
grid on;
ylabel('accuracy');
title('predict accuracy');

[ax1,h1]=suplabel('Ground');
[ax3,h2]=suplabel('Predict','y');


orient portrait
print('-dps','suplabel_test')

save('SVM_Ypred.mat','Ypred');
save('SVM_Ytest.mat','Ytest');
