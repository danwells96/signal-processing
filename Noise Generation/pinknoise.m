function y = pinknoise(m, n)
%PINKNOISE Summary of this function goes here
%   Detailed explanation goes here
N = m*n;
if rem(N,2)
    M = N+1;
else
    M = N;
end

x = randn(1, M);
X = fft(x);
NumUniquePts = M/2 + 1;
k = 1:NumUniquePts;

X = X(1:NumUniquePts);
%Array right division './'
X = X./sqrt(k);


X = [X conj(X(end-1:-1:2))];

y = real(ifft(X));

y = y(1, 1:N);
y = reshape(y, [m, n]);
y = bsxfun(@minus, y, mean(y));
y = bsxfun(@rdivide, y, std(y));

end

