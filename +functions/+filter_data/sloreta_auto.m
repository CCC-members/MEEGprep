function [J, W_slor, lambda_opt] = sloreta_auto(L, V, C)
% sLORETA with automatic lambda selection by GCV
% Inputs
%   L : [nChan x nSrc] leadfield (fixed orientation)
%   V : [nChan x nTime] data matrix
%   C : [nChan x nChan] noise covariance (optional, defaults to I)
% Outputs
%   J         : [nSrc x nTime] sLORETA estimates
%   W_slor    : [nSrc x nChan] sLORETA inverse operator
%   lambda_opt: chosen regularization parameter (scalar)

    if nargin < 3 || isempty(C), C = eye(size(L,1)); end

    % --- Whitening ---
    U = chol(C + 1e-12*eye(size(C)),'lower');
    Lw = L / U; 
    Vw = V / U; 

    % --- SVD for efficiency ---
    [U_s, svals, V_s] = svd(Lw,'econ'); 
    s = diag(svals); 

    % --- GCV function ---
    gcv = @(lam) sum( (s.^2 ./ (s.^2 + lam)).^2 ) - ...
                 2*sum( s.^2 ./ (s.^2 + lam) ) + ...
                 size(Lw,1);
    % Equivalent simpler form:
    % GCV(lam) = || (I - H_lam) Vw ||^2 / (trace(I - H_lam)^2)
    % but here we use a reduced SVD form.

    % --- Scan λ on a log grid and minimize GCV ---
    lam_grid = logspace(-6,2,60); 
    gcv_vals = zeros(size(lam_grid));
    for k=1:length(lam_grid)
        lam = lam_grid(k);
        H = U_s * diag(s.^2 ./ (s.^2 + lam)) * U_s';
        resid = Vw - H*Vw;
        num   = sum(resid(:).^2);
        den   = (trace(eye(size(Lw,1)) - H))^2;
        gcv_vals(k) = num/den;
    end
    [~,kopt] = min(gcv_vals); 
    lambda_opt = lam_grid(kopt);

    % --- Compute MNE with optimal λ ---
    LtL = Lw.'*Lw;
    W = (LtL + lambda_opt*eye(size(LtL))) \ (Lw.');
    R = W*Lw; 
    d = sqrt(max(diag(R),1e-15));
    W_slor = W ./ d; 

    J = W_slor * Vw;
end