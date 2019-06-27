% version 0.0
% classify DoA-Azimuth(phi) by input of signals received at vecotor sensor
% baseline: Wong's ESPIRT
% signal model: Wong's ESPRIT, this version get elevation(theta) FIXED
% distinct resolution(min azimuth degree unit): 1'. start from 18' first


numClasses    = 360;   %
RESOLUTION    = 1;
vecLabel      = 0:1:359;
NumSig        = 1;
maxEpochs     = 50;
miniBatchSize = 300;  %
SizeTrain     = 20000;
SizeTest      = SizeTrain*0.20;


%========   PART I : synthesised signal for data set ==================

% phi: azimuth angle, [0,2*pi)  -> [0, 2*pi]

% function approximation/ classification
% final var: K, [theta, phi, gamma, ita], [f, P, phase], dt,N, delta


% question: can esprit not know size? does ML not require size (for input or padding)?

% allData = cell(226800,1);
% allDataLabel = zeros(226800,1);
% % 35*71*18 = 44730 / 40000
% % % 35*360*18 = 226800 / 22k
% tic;
% i = 0;
% for theta1 = (5:5:175)*pi/180
%     for phi1Index = 0:1:359
%         for gamma1 = (5:5:90)*pi/180
%             
%             phi1 = phi1Index*pi/180;
%              
%             i = i + 1;
%             theta = [58.6   26.7 51.4 30.0    48.6]./180*pi;
%             phi   = ( [360-57.4 360-69.1 13.3 106.3 360-170.8])./180*pi;
%             gamma = [0     1/2   3/4  1/4      1/4]*pi;
%             ita   = [0     0     0    1/2      1/2]*pi;
%             
%             theta(1) = theta1;
%             phi(1)   = phi1;
%             gamma(1) = gamma1;
%             
%             K     = length(theta);
%             f = [ 0.75 0.55 0.65 0.85 0.45 ];
%             % only one signal
%             % P     = [1 1 1 1 1];
%             P     = [1 0 0 0 0];
%             Phase = rand(1,K)*2*pi;
%             dt     = 0.10;  % sample rate
%             N      = 200;    % number of snapshot
%             deltaT = 5 * dt;
%             
%             a = zeros(6,K);
%             for k = 1:K
%                 Theta = [ cos(theta(k))*cos(phi(k)) -sin(phi(k)); ...
%                     cos(theta(k))*sin(phi(k)) cos(phi(k)); ...
%                     -sin(theta(k))            0;...
%                     -sin(phi(k))              -cos(theta(k))*cos(phi(k));...
%                     cos(phi(k))               -cos(theta(k))*sin(phi(k));...
%                     0                         sin(theta(k))...
%                     ];
%                 g = [sin(gamma(k))*exp(1j*ita(k))   cos(gamma(k)) ].';
%                 a(:,k) = Theta * g;
%             end
%             
%             A1 = a;
%             s = zeros(K, N);
%             for t = 1:N
%                 for k = 1:K
%                     s(k, t) = sqrt(P(k)) * exp( 1j*(2*pi*f(k)*t*dt+Phase(k) ) );
%                 end
%             end
%             
%             std = 0.0001;
%             n = std * rand(6, N) + 1j * std * rand(6, N);
%             
%             
%             Zc = zeros(6,N);   % 12*N
%             for t = 1:N
%                 Zc(:,t) = A1 * s(:,t) + n(:,t);
%             end
%             
%             Z = zeros(12,N); 
%             Z(1:6,:)  = real(Zc);
%             Z(7:12,:) = imag(Zc);
%             
%             S = Z * Z';   % 12 * 12 matrix
%             S = tril(S); % lower triangle
%             S = nonzeros(S);
%             S = reshape(S,[],1);
%             S = normalize(S);
%             allData(i) = mat2cell(S,[78]);
%             allDataLabel(i) = phi1Index;
%             
%             if mod(i,1000) == 0
%                 disp(i);
%             end
%             
%         end
%     end
% end
% 
% allDataLabel = categorical(allDataLabel);
% 
% 
% % permute
% for i = 1:10
%     permID = randperm(numel(allData));
%     allData = allData(permID);
%     allDataLabel = allDataLabel(permID);
% end 
% 
% save('allData.mat','allData');
% save('allDataLabel.mat','allDataLabel');
% disp('synthesis data saved !');
% 
% toc;





load('allData.mat');
load('allDataLabel.mat');


% slice train & test set
Xtrain = allData(1:SizeTrain);
Ytrain = allDataLabel(1:SizeTrain);
save('Xtrain.mat','Xtrain');
save('YtrainLabel.mat','Ytrain');
Xtest = allData(SizeTrain+1:SizeTrain+SizeTest);
Ytest = allDataLabel(SizeTrain+1:SizeTrain+SizeTest);
save('Xtest.mat','Xtest');
save('YtestLabel.mat','Ytest');


% ====== load ========

load('Xtest.mat');
load('YtestLabel.mat');
load('Xtrain.mat');
load('YtrainLabel.mat');
load('allData.mat');
load('allDataLabel.mat');



% Xtrain = allData(1:20000);
% Ytrain = allDataLabel(1:20000);
% 
% Xtest = allData(20001:30000);
% Ytest = allDataLabel(20001:30000);





%========   PART II : tranning ==========================================
% ref code: https://www.mathworks.com/help/deeplearning/examples/...
% classify-sequence-data-using-lstm-networks.html#responsive_offcanvas

inputSize      =  78;  %  12*13/2
numHiddenUnits = 100;


layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(numHiddenUnits,'OutputMode','sequence')
    bilstmLayer(numHiddenUnits,'OutputMode','sequence')
    bilstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer]



options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'GradientThreshold',10, ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest', ...
    'Shuffle','every-epoch', ...
    'Verbose',1, ...
    'Plots','training-progress', ...
    'InitialLearnRate',0.01,...
    'OutputFcn',@(info)savetrainingplot(info));

net = trainNetwork(Xtrain,Ytrain,layers,options);
disp('training over!');

%========   PART III : testing ============================================

[YpredInt, score] = classify(net,Xtest, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest');

acc = sum(YpredInt == Ytest)./numel(Ytest)

YpredFloat = score * vecLabel';

err = double(Ytest)* RESOLUTION -  YpredFloat;

for i = 1:length(err)
    if err(i) >= 180
        err(i) = err(i) - 180;
    elseif err(i) <= -180
         err(i) = err(i) + 180;
    end
end



figure;
histogram(err);
clear title xlabel ylabel;
title('estimate error histogram');
xlabel('estimate error (deg)');
ylabel('count');
grid on;
saveas(gcf,'hist.png');



figure;
clear title xlabel ylabel;
scatter(YpredFloat,double(Ytest)* RESOLUTION);
grid on;
title('ML estimate vs ground')
xlabel('estimate ML');
ylabel('ground');
saveas(gcf,'scatter.png');


% trim the error, e.g. 359 and 0 does not make big diff in reality

errM = mean(err)

errVar = var(err)

% send email
title = sprintf('VectorDoA acc = %.2f, mean error %.2f degree', acc, errM);
content = sprintf('resultion = %d, NumSig = %d ,maxEpochs = %d, ,miniBatchSize = %d',...
    RESOLUTION, NumSig, maxEpochs, miniBatchSize);
attachment = {'train.png','hist.png','ClassifyAzimuth.m'};
sendEmail(title,content,attachment);
