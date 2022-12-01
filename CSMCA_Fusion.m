function imgf = CSMCA_Fusion(img1, img2, Dc, Dt)

% s1=double(img1)/255;
% s2=double(img2)/255;
s1=img1;
s2=img2;

npd = 16;
fltlmbd =60;
[s1_l, s1_h] = lowpass(s1, fltlmbd, npd);
[s2_l, s2_h] = lowpass(s2, fltlmbd, npd);

% source image decomposition
iters=6;
[Xc1,Xt1]=CSMCA(s1_h, iters, Dc, Dt);
[Xc2,Xt2]=CSMCA(s2_h, iters, Dc, Dt);

% fusion 
Xc=coef_fusion(Xc1,Xc2,5);
Xt=coef_fusion(Xt1,Xt2,2);

%reconstruction
s_h_c = ifft2(sum(bsxfun(@times, fft2(Dc, size(Xc,1), size(Xc,2)), fft2(Xc)),3),'symmetric');
s_h_t = ifft2(sum(bsxfun(@times, fft2(Dt, size(Xt,1), size(Xt,2)), fft2(Xt)),3),'symmetric');

s_l=(s1_l+s2_l)/2;

s=s_l+s_h_c+s_h_t;


imgf=s;
% imgf=uint8(s*255);