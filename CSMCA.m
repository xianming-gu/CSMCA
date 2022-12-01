function [Xc, Xt]= CSMCA(s, iters, Dc, Dt)

[h,w]=size(s);

xc=zeros(h,w);
xt=zeros(h,w);

for i=1:2*iters
    residue=s-xt-xc;
    kk=mod(i,2);
    iter=round(i/2);
    % update cartoon component
    if kk==1
        xc=xc+residue;
        D=Dc;
        lambda_c=max(0.6-0.1*iter,0.005);  %For texture 1
        opt_c = [];
        opt_c.Verbose = 10;
        opt_c.MaxMainIter = 30;
        opt_c.rho = 50*lambda_c + 1;
        opt_c.RelStopTol = 1e-3;
        opt_c.AuxVarObj = 0;
        opt_c.HighMemSolve = 1; 
        [Xc, optinf] = cbpdn(D, xc, lambda_c, opt_c);
        DX = ifft2(sum(bsxfun(@times, fft2(D, size(Xc,1), size(Xc,2)), fft2(Xc)),3), ...
           'symmetric');
        xc=DX;      
    end
    % update texture component
    if kk==0     
        xt=xt+residue;
        D=Dt;    
        lambda_t=max(0.6-0.1*iter,0.005);   
        opt_t = [];
        opt_t.Verbose = 1;
        opt_t.MaxMainIter = 30;
        opt_t.rho = 10*0.1;
        opt_t.RelStopTol = 1e-3;
        opt_t.AuxVarObj = 0;
        opt_t.HighMemSolve = 1;
        [Xt, optinf] = cbpdn(D, xt, lambda_t, opt_t);
        DX = ifft2(sum(bsxfun(@times, fft2(D, size(Xt,1), size(Xt,2)), fft2(Xt)),3), ...
           'symmetric');
        xt=DX;
    end          
    if mod(i,2)==1
%         fprintf('iteration %d \n',iter)     
    end
end