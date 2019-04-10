function [d,diter1,diter2]=evaluator(p,niter1,niter2,m,d)
%Decay terms using "p.Tn","p.K2","p.Cn" rates
d.R1(:)=((niter1(:,1)+p.n0).*(niter1(:,2)+p.p0))./(p.Tp*(niter1(:,1)+p.n0)+p.Tn*(niter1(:,2)+p.p0));% SRH recombination in bulk, linear // n or p dependent
d.R2(:)=p.K2*((niter1(:,1)+p.n0).*(niter1(:,2)+p.p0));%Radiative recombination in bulk, quadratic // n*p dependent
d.R3(:)=p.Cn*((niter1(:,1)+p.n0).*(niter1(:,2)+p.p0).^2)+p.Cp*((niter1(:,2)+p.p0).*(niter1(:,1)+p.n0).^2);%Auger recomb, cubic // n*p2 or n2*p dependent


%calculating first transfer to calculate full pero dynamics (n=1,2)
%Extra transport in front layer with "p.STn", and "p.STp"      
d.transfer(1)=p.SR*((niter1(m.L1,1)+p.n0)*(niter1(m.L1,2)+p.p0)/(niter1(m.L1,1)+p.n0+niter1(m.L1,2)+p.p0)); % Interface flux, can go to triplets or recomb
d.transfer(2)=p.STp*((niter1(m.L1,2)+p.p0)-niter2(1,2)*p.Texp(2)); %Transfer Flux of holes to rubrene (JTp=FTp*q) 
% Triplet gen: implied: not everything in transfer(1) making triplets is MAPI recombination
d.TG=p.TG*d.transfer(1); % TG ranges 0-1, yield of triplet gen from np product at interface

% Diffusion terms "d.Dn" calculated with Finite Difference Approximation
%between populations, divided by square of cell-to-cell distance (cell thickness), using "p.Dn" coefficient

for i=2:m.L1-1
    d.Dn(i,1)=p.Dn*(niter1(i+1,1)-2*niter1(i,1)+niter1(i-1,1))/m.d1^2;
    d.Dn(i,2)=p.Dp*(niter1(i+1,2)-2*niter1(i,2)+niter1(i-1,2))/m.d1^2;
end
d.Dn(1,1)=p.Dn*(niter1(2,1)-niter1(1,1))/m.d1^2;
d.Dn(m.L1,1)=p.Dn*(-niter1(m.L1,1)+niter1(m.L1-1,1))/m.d1^2-d.transfer(1)/m.d1;
d.Dn(1,2)=p.Dp*(niter1(2,2)-niter1(1,2))/m.d1^2;
d.Dn(m.L1,2)=p.Dp*(-niter1(m.L1,2)+niter1(m.L1-1,2))/m.d1^2-(d.transfer(1)+d.transfer(2))/m.d1;

%1st order decay terms, using decay rates "p.K1T","p.K1S","p.K1h"
d.RTE(:)=p.K1T*(niter2(:,1)); %triplet decay

%molecular fusion/fission/charge annihilation terms
d.TF(:)=p.KTTA*(niter2(:,1)).^2; %triplet fusion term
d.TCA(:)=p.KTCA*(niter2(:,1).*niter2(:,2));% triplet Charge annihilation 

%Diffusion in rubrene
for i=2:m.L2-1
    d.DTE(i)=p.DTE*(niter2(i+1,1)-2*niter2(i,1)+niter2(i-1,1))/m.d2^2;  %TE diffusion
    d.Dh (i)=p.Dh *(niter2(i+1,2)-2*niter2(i,2)+niter2(i-1,2))/m.d2^2;  %Holes in Rub diffusion
end
d.DTE(1)=p.DTE*(niter2(2,1)-niter2(1,1))/m.d2^2+d.TG/m.d2;  %TE diffusion
d.DTE(m.L2)=p.DTE*(niter2(m.L2-1,1)-niter2(m.L2,1))/m.d2^2;  %TE diffusion
d.Dh(1)=p.Dh*(niter2(2,2)-niter2(1,2))/m.d2^2+d.transfer(2)/m.d2;
d.Dh(m.L2)=p.Dh*(niter2(m.L2-1,2)-niter2(m.L2,2))/m.d2^2;

%derivative / infinitesimal iteration diter1
diter1(:,1)= - d.R1(:) - d.R2(:) - d.R3(:) + d.Dn(:,1); % sum of terms
diter1(:,2)= - d.R1(:) - d.R2(:) - d.R3(:) + d.Dn(:,2); %

%%derivative / infinitesimal iteration diter2
diter2(:,1)= - d.RTE(:)  - 2*d.TF(:) - d.TCA(:) + d.DTE(:); %sum of terms for each cell
diter2(:,2)=                                      + d.Dh(:);        

end
