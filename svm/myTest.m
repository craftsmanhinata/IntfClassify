

X = load('Xtrain.mat');
training_instance_matrix = cell2mat(X.Xtrain)';
Y = load('Ytrain.mat');
training_label_vector = double(Y.Ytrain);

tic;
model = svmtrain(training_label_vector, training_instance_matrix, ['libsvm_options']);
toc;

X2 = load('Xtest.mat');
testing_instance_matrix = cell2mat(X2.Xtest)';
Y2 = load('Ytest.mat');
testing_label_vector = double(Y2.Ytest);

[predicted_label] = svmpredict(testing_label_vector,  ...
                                testing_instance_matrix, ...
                                model, ['libsvm_options']);
                            
acc = sum(Ypred == Ytest)./numel(Ytest)

Ypred = double(predicted_label)';
Ytest = double(testing_label_vector)';
plotConfMat(myCalConfusionMatrix(Ytest,Ypred), intfName);
saveas(gcf,'confusionMatrix.png');