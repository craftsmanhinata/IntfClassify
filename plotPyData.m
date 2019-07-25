
intfName = { 'awgn', 'tone', 'chirp', 'filtN','copyCat'};
Ypred = load('DNN_Ypred.mat');
Ypred = Ypred.y_pred;
Ytest = load('DNN_Ytest.mat');
Ytest = Ytest.y_test;
plotConfMat(myCalConfusionMatrix(Ytest',Ypred'), intfName);
saveas(gcf,'DNN_confusionMatrix.png');