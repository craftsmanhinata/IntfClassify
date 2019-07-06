function X = myCalConfusionMatrix(a,b)

l = max(length(unique(a)),length(unique(b)));
X = zeros(l,l);
for i = 1:length(a)    
    X(a(i),b(i)) = X(a(i),b(i))+1;
end


end