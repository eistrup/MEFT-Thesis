function [x,T]=values(modal)
%vars=cell(25,1);
i=0;
i=i+1;
vars(i)={'Tn'};f(i)=0;param(i,:)=[5, 10^-7];bound(i,:)=[0.01, 100];
i=i+1;
vars(i)={'Tp'};f(i)=0;param(i,:)=[8, 10^-7];bound(i,:)=[0.01, 100];
i=i+1;
vars(i)={'K2'};f(i)=0;param(i,:)=[4, 10^-11];bound(i,:)=[0.01, 100];
%vars(i)={'K2'};f(i)=0;param(i,:)=[12, 10^-11];bound(i,:)=[0.01, 100];
i=i+1;
vars(i)={'Cn'};f(i)=0;param(i,:)=[4, 10^-28];bound(i,:)=[0.01, 100];
i=i+1;
vars(i)={'Cp'};f(i)=0;param(i,:)=[4, 10^-28];bound(i,:)=[0.01, 100];
i=i+1;
vars(i)={'p0'};f(i)=0;param(i,:)=[3, 10^15];bound(i,:)=[0.01, 100];
i=i+1;
vars(i)={'n0'};f(i)=0;param(i,:)=[0, 10^15];bound(i,:)=[0.01, 100];
i=i+1;
vars(i)={'Dn'};f(i)=0;param(i,:)=[5, 10^-1];bound(i,:)=[0.01, 100];
i=i+1;
vars(i)={'Dp'};f(i)=0;param(i,:)=[5, 10^-1];bound(i,:)=[0.01, 100];
i=i+1;
vars(i)={'TG'};f(i)=1;param(i,:)=[1, 10^-3];bound(i,:)=[0.01, 100];
i=i+1;
vars(i)={'SR'};f(i)=0;param(i,:)=[3, 10^3];bound(i,:)=[0.01, 100];
i=i+1;
vars(i)={'STp'};f(i)=0;param(i,:)=[5,10^3];bound(i,:)=[0.01, 100]; %i=i+1;
i=i+1;
vars(i)={'WCB'};f(i)=0;param(i,:)=[3, 10^-1];bound(i,:)=[0.01, 100];
i=i+1;
vars(i)={'WVB'};f(i)=0;param(i,:)=[0, 10^-1];bound(i,:)=[0.01, 100]; %WIGGLE HERE
i=i+1;
vars(i)={'K1T'};f(i)=0;param(i,:)=[1, 10^4];bound(i,:)=[0.01, 100];
i=i+1;
vars(i)={'DTE'};f(i)=1;param(i,:)=[5, 10^-5];bound(i,:)=[0.01, 100];
%vars(i)={'DTE'};f(i)=1;param(i,:)=[2.4, 10^-8];bound(i,:)=[0.01, 100];
i=i+1;
%vars(i)={'Dh'};f(i)=0;param(i,:)=[65, 10^-6];bound(i,:)=[0.01, 100];
vars(i)={'Dh'};f(i)=0;param(i,:)=[0, 10^-4];bound(i,:)=[0.01, 100];
%vars(i)={'Dh'};f(i)=0;param(i,:)=[7, 10^-5];bound(i,:)=[0.01, 100];
i=i+1;
vars(i)={'Rc'};f(i)=0;param(i,:)=[0, 10^-8];bound(i,:)=[0.01, 100];
i=i+1;
vars(i)={'KTTA'};f(i)=1;param(i,:)=[1, 10^-11];bound(i,:)=[0.01, 100];
i=i+1;
vars(i)={'KTCA'};f(i)=0;param(i,:)=[5, 10^-10];bound(i,:)=[0.01, 100];



%c-Rub %f(i)=0; DTE_0=3.5;        DTE_factor=10^-3;  DTE_lower=0.1;      DTE_upper=10;
%hole mobility up to 0.01, after improving 2 orders of magnitude. Then
%start with 0.0001 and x0.025 to get Dh becoming Dh=10-6
%TE Diff is approx (Dh)^2


%FITTING GLOBAL
T=table(vars',param(:,1),param(:,2),f',bound(:,1),bound(:,2));
[x]=parameter(T,0,modal.norm,1); %option=1 set values for fit

end



% i=i+1;
% vars(i)={'TG'};f(i)=1;param(i,:)=[0, 10^-2];bound(i,:)=[0.01, 100];
% i=i+1;
% vars(i)={'SR'};f(i)=0;param(i,:)=[0, 10^2];bound(i,:)=[0.01, 100];
% i=i+1;
% vars(i)={'ST'};f(i)=0;param(i,:)=[0, 10^3];bound(i,:)=[0.01, 100];
% i=i+1;
% vars(i)={'STp'};f(i)=0;param(i,:)=[0, 10^3];bound(i,:)=[0.01, 100];

