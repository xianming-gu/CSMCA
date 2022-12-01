function X= coef_fusion(X1, X2, r)

A1=sum(abs(X1),3);
A2=sum(abs(X2),3);
r1=2*r+1;
ker=ones(r1,r1)/(r1*r1);
AA1=imfilter(A1,ker);
AA2=imfilter(A2,ker);
decisionMap=AA1>AA2;
[height,width]=size(A1);
X=X1;
for j=1:height
    for i=1:width
        if decisionMap(j,i)==0
            X(j,i,:)=X2(j,i,:);
        end
    end
end