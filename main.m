clear all;hold off;

list.irf=[('./data/IRF_A_bin02.dat');('./data/IRF_A_bin02.dat');('./data/IRF_B_bin01.dat');]; %PHA-time data
list.x=[('./data/b040-sXX-Apower-x_bin02.dat');('./data/b040-sXX-Apower-x_bin02.dat');('./data/b036-sXX-Bpower-x-bin01.dat'); ];
list.y=[('./data/b040-sXX-Apower-y.dat');('./data/b040-sXX-Apower-y.dat');('./data/b036-sXX-Bpower-y.dat');];
list.z=[('./data/b040-s150Apower-z_bin02.dat');('./data/b040-s16-Apower-z_bin02.dat');('./data/b036-s16-Bpower-z-bin01.dat'); ];

%m. conditions
m.Lexc=705*10^-9; %nm to m
m.diam=25*10^-4;%40*10^-4; %um to cm
m.frep=250*10^3; %Hz
m.alpha=1*10^4; %extract from UVVis or litterature
m.H1=500*10^-7; %MAPI layer thickness nm to cm
m.H2=100*10^-7; %Overlayer layer thickness nm to cm
m.L1=10; %discretization of MAPIC layer
m.L2=50; %discretization of Rubrene layer
m.d1=m.H1/m.L1;
m.d2=m.H2/m.L2;
%Modeling conditions
m.binsize=1;%BINNING 1 to 64 %toff has to be bigger than binsize
m.toff=2*10^-8; %OFFSET subtraction PAY ATTENTION HERE, CHANGES FOR EACH TYPE OF DATA
m.tcut=8000*10^-9; %Time cut in nsec, not below 100nsec
m.resolution=round(5); %Res=150 should be OK %Res=250 to also work with step8nsec of f125kHz %resolution=modeling.resolution;
m.norm=1;
m.glob=[2;3];%glob= scans the rubrene-over options 1=Aunquenched; 2=Aquenching; 3=SEemission (K1T,K1S); 4=SEemission (KTTA,KSF)
m.pow=[7;7];%pow=[3;3]; %to which power data we wanna fit, inicial-final
m.par=0;%parallel computing
%parpool(m.par);%needs to be done in beginning only (~13sec 2workers)
m.out=2; %output of model is 0=time array; 1=time array & file writing; 2=file writing; 
m.plot=1; %what to plot: 1=transients;2=; 3=; 4= cross sections
m.cross=0; % =1, write and plot cross-section of populations
m.last=1;  % 1=write last files; 2=read+write last files (must be written in previous run) , 3=only read last files
m.fit=0; %=1 fit; =0 plot; =2 calc&plot integrator; 3=fit both integrator and simfit

%obtaining the data itself from files
[data]=treatment(list,m);
%generating the fit-parameter x array and the global parameters T table
[x,T]=values(m);%xstart=x(:,1);xlower=x(:,2);xupper=x(:,3);
xfit=x(:,1);

switch m.fit
    case 1
        xfit=fmincon('simfit',x(:,1),[],[],[],[],x(:,2),x(:,3),'','',T,data,m,1) %last paramater resolutio
        m.fit=0;m.par=0;
    case 0
        m.cross=1;
        m.par=0;
        m.last=0;
        data=simfit(xfit,T,data,m,0);
        %m.last=2;
        %for k=1:5
        %data=simfit(xfit,T,data,m,0);
        %end
        m.plot=1;
        transplot(data,T,x,m);
    case 2
        m.last=1;
        [integ,dinteg]=integrator(xfit,data(3).t,T,m);
        m.last=2;
        for k=1:40
        [integ,dinteg]=integrator(xfit,data(3).t,T,m);
        end
       integplot(integ,dinteg, m);         
    case 3
        %xfit=fmincon('globalfit',x(:,1),[],[],[],[],x(:,2),x(:,3),'','',T,data,m); %last paramater resolutio
    case 4 %spectral integration
        [sum15,sum16]=spectral(data,power,m);
end