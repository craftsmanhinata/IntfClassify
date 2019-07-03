function ap = alphaProfile(x,Nw,da,a1,a2)
% return alpha profile of signal x
% Nw: window length
% da: cyclic frequency resolution
% a1: first cyclic freq. bin to scan (i.e. cyclic freq. a1*da)
% a2: last cyclic freq. bin to scan (i.e. cyclic freq. a2*da)

L    = length(x);
da   = da/L;
Nv   = fix(2/3*Nw);	% block overlap
nfft = 2*Nw;		% FFT length
Fs   = 10;			% sampling frequency in Hz

% Loop over cyclic frequencies
C = zeros(nfft,a2-a1+1);
for k = a1:a2
    Coh = SCoh_W(x,x,k/L,nfft,Nv,Nw,'sym');    
    C(:,k-a1+1) = Coh.C;
end


% alpha = Fs*(a1:a2)*da;
% f = Fs*Coh.f(1:nfft/2);

T = C(1:nfft/2,:);
T = T';  % alpha X f
T = abs(T);
l1 = a2-a1+1;
ap = zeros(1,l1);
for i = 1:l1
    ap(i) = max(T(i,:));
end


end