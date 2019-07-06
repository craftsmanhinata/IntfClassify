% clear all;
% close all;
% 
% bitLen = 10000;
% SNRdB = 10;
% SIRdB = 0;
% 
% intfName = { 'awgn', 'tone', 'chirp', 'filtN','copyCat'};
% numClass = length(intfName);
% 
% 
% sps = 4;
% sigLen = bitLen/sps;
% s = sign(randn(1,sigLen))+1j*sign(randn(1,sigLen));
% p1 =[0.0266468801359843	-0.0276231535739088	-0.0855374118147732	-0.0998121297879238	-0.0322651579086280	0.119473681399052	0.312317558188603	0.473734829004615	0.536592673759239	0.473734829004615	0.312317558188603	0.119473681399052	-0.0322651579086280	-0.0998121297879238	-0.0855374118147732	-0.0276231535739088	0.0266468801359843];
% s = conv(upsample(s,sps),p1);
% s = s(1:bitLen);
%     
% 
% 
% Nw = 256;
% da = 1;
% a1 = 51;
% a2 = 400;
% 
% 
% ap_x = alphaProfile(s,Nw, da,a1,a2);
% 
% 
% for j = 1:numClass
%     intfType = intfName(j);
%     
%     if strcmp(intfType,'awgn')       
%         x = 1/sqrt(2*10^(SNRdB/10))*(randn(1, bitLen) + 1j*randn(1, bitLen));
%         
%     elseif strcmp(intfType,'tone')       
%         freq_c = 0.01;
%         x = 1/sqrt(2*10^(SIRdB/10))*exp(1j* 2*pi * freq_c * [1:bitLen])+...
%             1/sqrt(2*10^(SNRdB/10))*(randn(1, bitLen) + 1j*randn(1, bitLen));
%         
%     elseif strcmp(intfType,'chirp')
%         f_s = 0.01;
%         f_t = 0.40;
%         x = 1/sqrt(2*10^(SIRdB/10))*myChirp(f_s,f_t,bitLen)+...
%             1/sqrt(2*10^(SNRdB/10))*(randn(1, bitLen) + 1j*randn(1, bitLen));
%         
%     elseif strcmp(intfType,'filtN')  
%         a = 0.20;
%         x = 10 * 1/sqrt(2*10^(SIRdB/10)) * filter(a,[1 a-1],randn(1,bitLen)+1j*randn(1,bitLen))+...
%             1/sqrt(2*10^(SNRdB/10))*(randn(1, bitLen) + 1j*randn(1, bitLen));
%         
%     elseif strcmp(intfType,'copyCat')
%         sps = 16;
%         sigLen = bitLen/sps;
%         s = sign(randn(1,sigLen))+1j*sign(randn(1,sigLen));
%         p2=[0.0133294045829483	0.00777030651457686	0.00123897509528740	-0.00604791284466589	-0.0138177598264617	-0.0217492345025039	-0.0294819671605503	-0.0366284653541104	-0.0427878522077968	-0.0475609348036246	-0.0505660333237387	-0.0514549472913709	-0.0499284063815163	-0.0457503518520167	-0.0387604214655622	-0.0288840653685093	-0.0161398010386978	-0.000643219182246266	0.0173925246735259	0.0376598611280455	0.0597635831382631	0.0832310824424753	0.107525737263410	0.132063008823302	0.156228686818484	0.179398628047102	0.200959262245959	0.220328098172476	0.236973453125156	0.250432651146802	0.260327988429086	0.266379846900254	0.268416445313014	0.266379846900254	0.260327988429086	0.250432651146802	0.236973453125156	0.220328098172476	0.200959262245959	0.179398628047102	0.156228686818484	0.132063008823302	0.107525737263410	0.0832310824424753	0.0597635831382631	0.0376598611280455	0.0173925246735259	-0.000643219182246266	-0.0161398010386978	-0.0288840653685093	-0.0387604214655622	-0.0457503518520167	-0.0499284063815163	-0.0514549472913709	-0.0505660333237387	-0.0475609348036246	-0.0427878522077968	-0.0366284653541104	-0.0294819671605503	-0.0217492345025039	-0.0138177598264617	-0.00604791284466589	0.00123897509528740	0.00777030651457686	0.0133294045829483];
%         s = conv(upsample(s,sps),p2);
%         copyCat = s(1:bitLen);
%         copyCat = (copyCat-mean(copyCat))/var(copyCat);
%         x = 1/sqrt(2*10^(SIRdB/10)) * copyCat +...
%             1/sqrt(2*10^(SNRdB/10))*(randn(1, bitLen) + 1j*randn(1, bitLen));
%     end
%     
% 
%     
% %     r = x + s;
%     
%     % ====== calculate =======
% 
%     tic;
% %     ap_r = alphaProfile(r,Nw, da,a1,a2);
%     temp = alphaProfile(x,Nw, da,a1,a2);
%     ap_x = [ap_x;temp];
%     toc;
%     
% 
% 
% end

ap_x = load('ap_x.mat');
ap_x = ap_x.ap_x;
    
figure;
% ====== polt ========

subplot(2,3,1);
plot(ap_x(1,:));
grid on;
title('signal of interest');
% xlabel('cyclic frequency \alpha [Hz]');
% ylabel('Maximum Cyclic Spectral Coherence');

subplot(2,3,2);
plot(ap_x(2,:));
grid on;
title('white noise');
% xlabel('cyclic frequency \alpha [Hz]');
% ylabel('Maximum Cyclic Spectral Coherence');

subplot(2,3,3);
plot(ap_x(3,:));
grid on;
title('tone');
% xlabel('cyclic frequency \alpha [Hz]');
% ylabel('Maximum Cyclic Spectral Coherence');

subplot(2,3,4);
plot(ap_x(4,:));
grid on;
title('chirp');
% xlabel('cyclic frequency \alpha [Hz]');
% ylabel('Maximum Cyclic Spectral Coherence');

subplot(2,3,5);
plot(ap_x(5,:));
grid on;
title('filter noise');
% xlabel('cyclic frequency \alpha [Hz]');
% ylabel('Maximum Cyclic Spectral Coherence');



subplot(2,3,6);
plot(ap_x(6,:));
grid on;
title('unknown modulated signal');
% xlabel('cyclic frequency \alpha [Hz]');
% ylabel('Maximum Cyclic Spectral Coherence');

[ax1,h1]=suplabel('cyclic frequency \alpha [Hz]');
[ax2,h2]=suplabel('Maximum Cyclic Spectral Coherence','y');
% [ax3,h2]=suplabel('super Y label (right)','yy');
% [ax4,h3]=suplabel('\alpha profile of interference'  ,'t');
set(h3,'FontSize',11)

orient portrait
print('-dps','suplabel_test')
