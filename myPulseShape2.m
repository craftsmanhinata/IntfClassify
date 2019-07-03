function s= myPulseShape2(s,sps,span,beta,shape)


% sps   = 4;
% 
% span  = 4;
% beta  = 0.25;
% shape = 'sqrt';
p                 = rcosdesign(beta,span,sps,shape);
rCosSpec          =  fdesign.pulseshaping(sps,'Raised Cosine',...
    'Nsym,Beta',span,0.25);
rCosFlt           = design ( rCosSpec );
rCosFlt.Numerator = rCosFlt.Numerator / max(rCosFlt.Numerator);

upsampled = upsample( s, sps);     % upsample
FltDelay  = (span*sps)/2;           % shift
temp      = filter(rCosFlt , [ upsampled , zeros(1,FltDelay) ] );
s        = temp(sps*span/2+1:end);        % to be fixed

end