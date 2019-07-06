clear all;
close all;

N = 2000;
SNRdB = 0;
SIRdB = 0;
Len1 = 10000;


 ap_x = zeros(6,50);
 
for j = 1:4
        
    N = 2000;
    bitsPerSym = j;
    sps = 4;
   
    bits = round(rand(1,N));
    if(mod(length(bits),bitsPerSym))
        bits = [bits zeros(1,bitsPerSym - mod(length(bits),bitsPerSym))];
    end
    bits = reshape(bits(:),bitsPerSym,[]);
    constellation = exp(1j*(0:2^bitsPerSym-1)*2*pi / 2^bitsPerSym);
    constIdx = zeros(1,size(bits,2));
    for i=1:bitsPerSym
        constIdx = constIdx + bits(i,:)*2^(i-1);
    end
    s = constellation(constIdx+1);
    
    p1 =[0.0266468801359843	-0.0276231535739088	-0.0855374118147732	-0.0998121297879238	-0.0322651579086280	0.119473681399052	0.312317558188603	0.473734829004615	0.536592673759239	0.473734829004615	0.312317558188603	0.119473681399052	-0.0322651579086280	-0.0998121297879238	-0.0855374118147732	-0.0276231535739088	0.0266468801359843];
    s1 = conv(upsample(s,sps),p1);
    
    x = [];
    while length(x) < Len1
        x = [x,s1];
    end
    x = x(1:Len1);
    
    % ====== calculate =======
    Nw = 256*4;
    da = 1;
    a1 = 51;
    a2 = 100;
    tic;  
    ap_x(j,:) = alphaProfile(x,Nw, da,a1,a2);
    toc;

end

figure;
plot(ap_x(:,1:20)','LineWidth',2);
hold on;
grid on;
title('\alpha profile SNR 0 SIR 0');
xlabel('cyclic frequency \alpha [Hz]');
ylabel('Maximum Cyclic Spectral Coherence');
legend('BPSK','QPSK','8PSK','16PSK')


