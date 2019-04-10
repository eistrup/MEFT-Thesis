% Dynamics MODEL 
% Numerical solution: RUNGE-KUTTA 4th ORDER;

function [out] =model(x,T,power,ij_vect, m)
ipower=ij_vect(1); %power index
jglob=ij_vect(2);  %global mode index (Unquenched, Quenched, UC)

[p]=parameter(T,x,m.norm,0); %p is parameter structure; option=0 set values (fit vs free) for model

%treating first m parameters
[m,niter0]=experiment(power,T,m);

%jglob=1;
if jglob<2
    p.TG=0;p.STp=0;
end

Q=1; %Quantum Yield; Geometric Factor; Detection Factor

%TIME PARAMETERS
hl=m.resolution*m.tl; % full length of subiterations
h=(m.resolution^-1)*m.h0; % subiteration step
d.treal=0;%real time in nsec
tt=0; %writing iteration (every m.resolution x t steps)
k=m.resolution-1; %k is iterator; set to start in a way that a writing happens right away at t=1 and treal=0

%Convergence Condition:
%Convergence=2*p.Dn*h/(m.d1)^2

%Get distribution niter0 over the cells in perovskite layer
niter1(1:m.L1,1)=niter0(:)/m.d1; %input starting values of each cell as concentrations
niter1(1:m.L1,2)=niter0(:)/m.d1; %input starting values as concentrations for holes, niter becomes 2dim vector

% %allocating
    diter1(1:m.L1,1:2)=0; %infinitesimal variation
    niter2(1:m.L2,1:2)=0; %niter2 is populations for TE & SE & holes in rubrene
    diter2(1:m.L2,1:2)=0; %infinitesimal variation 
    d.treal=0;
    d.transfer(1:2)=0; %interface transfer rate
    d.Dn(1:m.L1,1:2)=0; %Diffusion Term
    d.R1(1:m.L1)=0; %1st order (SRH) decay
    d.R2(1:m.L1)=0; %2nd order (Radiative) decay term
    d.R3(1:m.L1)=0; %3rd order (Auger) decay term
    d.DTE(1:m.L2)=0;  d.Dh(1:m.L2)=0; %Diffusion terms in rubrene
    d.RTE(1:m.L2)=0; d.Rh(1:m.L2)=0; %1st order decay terms in rubrene
    d.TF(1:m.L2)=0; d.TCA(1:m.L2)=0; %fusion, fission, charge annihilation terms
    d.TG=0;d.transfer(1:2)=0;
    plqe(1:5)=0;
    
if m.last>1
    filename_import=strcat('./write/last_niter_',num2str(power),'.dat'); %open file
    last_niter=importdata(filename_import);
    niter2(:,1)=last_niter(:,1);
    niter2(:,2)=last_niter(:,2);
end
niter2(1,1)

    fileID.pl=0;
    [fileID]=writer(0,fileID,plqe,niter1,niter2,d.treal,power,ipower,jglob,m);
    writer(1,fileID,plqe,niter1,niter2,d.treal,power,ipower,jglob,m);

    %CYCLE!!!%Beginning the cycle for with t-step (t is subiteration)
for tt=1:m.tl-1
    %tt
    for k=1:m.resolution
    % evaluator = EVALUATES THE DERIVATIVE
    [d,k1diter1,k1diter2]=evaluator(p,niter1,niter2,m,d); %k1
    [d,k2diter1,k2diter2]=evaluator(p,(niter1+(h/2)*k1diter1),(niter2+(h/2)*k1diter2),m,d); %k2
    [d,k3diter1,k3diter2]=evaluator(p,(niter1+(h/2)*k2diter1),(niter2+(h/2)*k2diter2),m,d); %k2
    [d,k4diter1,k4diter2]=evaluator(p,(niter1+(h)*k3diter1),(niter2+(h)*k3diter2),m,d); %k2

    niter1(:,:)=niter1(:,:)+(h/6)*(k1diter1(:,:)+2*k2diter1(:,:)+2*k3diter1(:,:)+k4diter1(:,:)); 
    niter2(:,:)=niter2(:,:)+(h/6)*(k1diter2(:,:)+2*k2diter2(:,:)+2*k3diter2(:,:)+k4diter2(:,:)); 
    
    for i=1:m.L1
        if niter1(i,1)<p.n0
            niter1(i,1)=p.n0;
        end
        if niter1(i,2)<p.p0
            niter1(i,2)=p.p0;
        end
    end
    
    %%sum history of decay
    plqe(1)=plqe(1)+h*m.d1*(sum(d.R2(:))); %final PL signal of carriers  = PL1(t), RADIATIVE
    plqe(2)=plqe(2)+h*m.d1*(sum(d.R1(:))+sum(d.R2(:))+sum(d.R3(:))+d.transfer(1)/m.d1); % decay poulation , RADIATIVE+NONRADIATIVE electrons
    plqe(3)=plqe(3)+h*d.TG; %number of triplets formed 
    plqe(4)=plqe(4)+h*m.d2*(sum(d.TF(:))); %number of singlets formed
    plqe(5)=plqe(5)+h*m.d1*(sum(d.R1(:))+sum(d.R2(:))+sum(d.R3(:))+d.transfer(2)/m.d1); % decay poulation , RADIATIVE+NONRADIATIVE holes
    end
    d.treal=(tt)*m.h0; %real time update
    writer(1,fileID,plqe,niter1,niter2,d.treal,power,ipower,jglob,m); %write data to file
    plqe(:)=0;
end%end of time-for

writer(2,fileID,plqe,niter1,niter2,d.treal,power,ipower,jglob,m);

if m.fit==2
    writer(4,fileID,plqe,niter1,niter2,d.treal,power,ipower,jglob,m);
end
if m.last>0 || m.last<3
    writer(3,fileID,plqe,niter1,niter2,d.treal,power,ipower,jglob,m);
end

end