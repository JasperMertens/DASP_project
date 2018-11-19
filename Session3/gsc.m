L_coef = 1024;
mu = 0.1;

DAS_BF
DAS_out_delayed = [zeros(L_coef/2, 1); DAS_out];

blocking = -diag(ones(n-1,1),-1);
blocking(1,:) = ones(1,n);
blocking = blocking(:,1:end-1);

block = kron(eye(L_coef), blocking);

w = zeros(L_coef, n-1);
ones = ones(1,n-1);
output = zeros(length(mic)-L_coef-1,1);
for i=1:length(mic)-L_coef-1
    y_slice = mic(i:i+L_coef-1,:);
    y_flat = y_slice(:);
    y_hat = block.'*y_flat;
    x = reshape(y_hat, L_coef, n-1);
    d = DAS_out_delayed(i);
    output(i) = d - ones*diag(w.'*x);
    w = w + mu/norm(x,'fro')*x*output;
    
end