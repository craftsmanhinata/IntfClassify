intfName = { 'awgn', 'tone', 'chirp', 'filtN'};


% ====== svm main script =======
X = load('../X.mat');
X = cell2mat(X.X)';

Y = load('../Y.mat');
Y = double(Y.Y);

[len1, ~] = size(X); 

testLen = ceil(len1*0.10);

Xtest = X(1:testLen,:);
Xtrain = X(testLen+1:end,:);
Ytest = Y(1:testLen,:);
Ytrain = Y(testLen+1:end,:);

training_instance_matrix = Xtrain;
training_label_vector = Ytrain;
testing_instance_matrix = Xtest;
testing_label_vector = Ytest;

disp('-------- data loaded --------');


% X = load('Xtrain.mat');
% training_instance_matrix = cell2mat(X.Xtrain)';
% Y = load('Ytrain.mat');
% training_label_vector = double(Y.Ytrain);

tic;
model = svmtrain(training_label_vector, training_instance_matrix, ['libsvm_options']);
toc;

% X2 = load('Xtest.mat');
% testing_instance_matrix = cell2mat(X2.Xtest)';
% Y2 = load('Ytest.mat');
% testing_label_vector = double(Y2.Ytest);

[predicted_label] = svmpredict(testing_label_vector,  ...
                                testing_instance_matrix, ...
                                model, ['libsvm_options']);
                            


Ypred = double(predicted_label)';
Ytest = double(testing_label_vector)';

acc = sum(Ypred == Ytest)./numel(Ytest)

plotConfMat(myCalConfusionMatrix(Ytest,Ypred), intfName);
saveas(gcf,'SVM_confusionMatrix.png');