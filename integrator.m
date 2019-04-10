function [integ, dinteg, triplet, hole]=integrator(x,t,T,m)
tic



%IMPORT UCE data

dinteg.import=importdata(strcat('UC_s16.dat')); %open file
% x axis
dinteg.power=dinteg.import(:,1);
%m stuff
area=pi()*(m.diam/2)^2;
frepM=0.25*10^6; %ATTENTION HERE
%Ep=integ.power/frepM;
%Epd=Ep/area;
dinteg.Epd=dinteg.import(:,2);
dinteg.nexc=dinteg.import(:,3);
% UC axis
dinteg.UC=dinteg.import(:,4)./area; %ATTENTION, calculating on area density
dinteg.UCE=dinteg.import(:,5);



%integ(1:length(ij_vect(:,1)),1:3)=0; %alloc
%integ(1:kl,1:11)=0; %alloc

m.tl=find(t>1000*10^-9,1); %length of time data
m.h0=t(2)-t(1); %step/spacing of time data

%choose between powers
%integ.power=power_integ; 
if m.fit > 2
    integ.power=dinteg.power;
elseif m.fit<3
    %integ.power=logspace(-7,-4,20);
    integ.power=logspace(-7,-4,20);
end
integ.Epd=integ.power/frepM/area;

k=0;
kl=length(integ.power);
m.glob=[3,3];
m.pow=[1,kl];

parfor k=1:kl
%for k=1:kl
    %if integ.power(k)>10^-5
        %    m.resolution=m.resolution*2;
        %end
        
%CALL THE MODEL
model(x,T,integ.power(k),[k,3],m); %last parameter is flag
end


for k=1:kl %par is faster than normal for i + for j
        PLQE=importdata(strcat('./write/power_',num2str(integ.power(k)),'.dat'));
        integ.rad(k)=PLQE(1);%radiative MAPI
        integ.nonrad(k)=PLQE(2)-PLQE(1);%non-radiative MAPI
        integ.triplet(k)=PLQE(3);%Triplet formation
        integ.singlet(k)=PLQE(4);%Singlet formation Rubrene
        integ.triplet0(k)=PLQE(5);%initial Triplet population in Rubrene
        integ.nabs(k)=PLQE(6);%Full Absorbed photons MAPI
        integ.plqe(k)=PLQE(1)/PLQE(2); %PLQE calculation
        integ.tg(k)=PLQE(3)/PLQE(6); %TGE calculation (triplet energy transfer efficiency)
        integ.tf(k)=2*PLQE(4)/(PLQE(3)); %TFE calculation (triplet fusion efficiency), x2 = 100% when all 
        integ.uce1(k)=PLQE(4)/PLQE(6); %UCE calculation (upconversion efficiency) using pulse input 
        integ.uce2(k)=integ.tg(k)*integ.tf(k); %UCE calculation (upconversion efficiency) using TET and TF efficiencies
        %triplet=PLQE(6);
        %holes=PLQE(7);
        
end



if m.fit>=3
    p=polyfit(integ.power,integ.uce2',5);
    dinteg.eval=polyval(p,dinteg.power);
    d(1:length(dinteg.power))=0;
    for k=1:length(dinteg.power)
        d(k)=sum(((dinteg.eval(k)-dinteg.UCE(k)).^2)./dinteg.UCE(k))
    end
    dd=sum(d)
    output dd;
end

toc
end
