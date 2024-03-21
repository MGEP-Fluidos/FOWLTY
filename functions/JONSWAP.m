function [S,Hw,Pwave,Te] = JONSWAP(w,Tp,Hs,gamma)
nw=length(w);
f=w/(2.*pi);
A=0.3125*Hs^2/Tp^4;
B=1.25/Tp^4;
fp=1./Tp;
m0=0.;
m_1=0.;
Pwave=0.;
Hw=zeros(1,nw);
S=zeros(1,nw);
for i=2:nw
    fc=0.5*(f(i)+f(i-1));
    df=f(i)-f(i-1);
    S(i)=A/fc^5*exp(-B/fc^4);
    if (fc<fp)
        sigma=0.02;
        
    else
       sigma=0.25;
       
    end
    pa=exp(-(fc-fp)^2/(2.*sigma^2*fp^2));
    S(i)=S(i)*gamma^pa;
    m0=m0+S(i)*df;
    m_1=m_1+S(i)/fc*df;
end
alpha=Hs^2/(16.*m0);
Te=m_1/m0;
for i=2:nw
    df=f(i)-f(i-1);
    S(i)=S(i)*alpha;
    Hw(i)=sqrt(2.*S(i)*df);
    Pwave=Pwave+0.25*1025.*9.81*9.81*Hw(i)*Hw(i)/w(i);
end
end

