function [m,niter0]=experiment(power,T,m)

%L=length(table2array(T(:,1)));



h=6.626*10^-34; %J  %h=4.136*10^-15; %eV
c=2.8*10^8; %speed of light    
Ep=power/m.frep; %Joules per pulse
area=pi()*(m.diam/2)^2; %Diameter of spot in centimeter
Eph=h*c/m.Lexc; %Lexc in m
Nph0=(Ep/Eph/area);

for z=1:m.L1 %niter0(z) same as niter1(z);
    niter0(z)=10^(-m.alpha*((m.L1-z)*m.d1));
end
    m.full_abs=Nph0*(1-10^(-m.alpha*m.H1)); %method used to calculate alpha. RWM: full_abs is used by main to determine number of absorbed photons. Old: full_abs=Nph0*m.alpha*m.H1
    iterate_abs=sum(niter0(:));%iterative method employed here

    for i=1:length(power)
        niter0(:)=niter0(:)*(m.full_abs/iterate_abs); %normalization to first method
    end
end