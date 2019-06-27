% --------------------------------------------------------
% Inteference Signal Classification using Neural Network
% Jun, 2019
% Jet Yu, ECE, Virginia Tech
% jianyuan@vt.edu
% --------------------------------------------------------



% ======= generate intf type ========
% 4 type: awgn, tone, chirp, filtN(filtered noise, low-passed white noise)
% 1. awgn: SNR
% 2. tone: Ac#, theta_c #, freq_c
% 3. chirp: Ac#, theta_c #, freq_s #, freq_t
% 4. filtN: a

iterMAX = 3200;
bitLen = 2000;
intfName = { 'awgn', 'tone', 'chirp', 'filtN'};


% --- intference setting --
SNR    = -10  :(20-(-10))/(iterMAX-1)  :20;
freq_c = 0.01 :(0.40-0.01)/(iterMAX-1) :0.40;
f_s    = 0.001;
f_t    = 0.002:(0.40-0.002)/(iterMAX-1):0.40;
a      = 0.01 :(0.50-0.01)/(iterMAX-1) :0.50;

% X = [];
Y = [];

tic;
for i = 1:iterMAX
    for j = 1:4
        intfType = intfName(j);
        if strcmp(intfType,'awgn')
            x = randn(1, bitLen) + 1j*randn(1, bitLen);
            y = 1;
        elseif strcmp(intfType,'tone')
            x = exp(1j* 2*pi * freq_c(i) * [1:bitLen]) ;
            y = 2;
        elseif strcmp(intfType,'chirp')
            x = myChirp(f_s,f_t,bitLen);
            y = 3;
        elseif strcmp(intfType,'filtN')
            x = filter(a(i),[1 a(i)-1],randn(1,bitLen)+1j*randn(1,bitLen));
            y = 4;
        end
        
        %    figure;
        %    plot(abs(fftshift(fft(x))));
        
        % fft
        isFFT = 1;
        if isFFT
            x = fft(x);
        end
        
        % normalize
%         x = [real(x),imag(x)];
        x = abs(x);
        x = reshape(x,[],1);
        x = normalize(x);
        X((i-1)*4+j) = mat2cell(x,[2000]);
        
        
        
        Y = [Y;y];
        
        if mod(i,1000) == 0
            processMsg = sprintf('data generating %.2f %%', i*100.0/iterMAX);
            disp(processMsg);
            toc;
        end

    end
end

save('X.mat','X');
save('Y.mat','Y');

Y= categorical(Y);

Size = numel(X);

% permute
for i = 1:10
    permID = randperm(Size);
    X = X(permID);
    Y = Y(permID);
end 

SizeTrain = floor(Size*0.90);
Xtrain = X(1:SizeTrain);
Ytrain = Y(1:SizeTrain);

Xtest = X(SizeTrain+1:Size);
Ytest = Y(SizeTrain+1:Size);




% ====== (Pending) convert data into figure =======



% =======  Neural Network ===========
inputSize      =  2000;  %  12*13/2
numHiddenUnits = 100;
numClasses = 4;
maxEpochs     = 20;
miniBatchSize = 300;  


layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(200,'OutputMode','sequence')
    bilstmLayer(200,'OutputMode','sequence')
   
    bilstmLayer(200,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];



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


% =======  Plot ===========
% using confusion matrix

[Ypred, score] = classify(net,Xtest, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest');

acc = sum(Ypred == Ytest)./numel(Ytest)
