
function [final]=treatment(list,modal)

ll=length(list.z(:,1)); %number of imported data, unquenched+queched+Bquenched=3
for i=1:ll
        data(i).time  =importdata(list.x(i,:))*10^-9;tl(i)=length(data(i).time); %time import
        data(i).power =importdata(list.y(i,:));%power import
        data(i).data  =importdata(list.z(i,:));l(i)=length(data(i).data(1,:)); %data import
        data(i).irf   =importdata(list.irf(i,:));        
end
%find(data(3).data(5000:end,7)==0,1)

for i=modal.glob(1):modal.glob(2)
    %OFFSET SUBTRACTION  RWM, currently disabled
    ttoff=find(data(i).time>modal.toff,1);
    data(i).data_off=data(i).data(:,:); %-mean(data(i).data(1:ttoff,:));
    %BINNING
    [data(i).time,data(i).data]=binning(data(i).time,data(i).data_off,modal.binsize); %last parameter: binsize 1,2,4,8,16,32,64
    [data(i).time,data(i).irf]=binning(data(i).time,data(i).irf(:,2),modal.binsize); %last parameter: binsize 1,2,4,8,16,32,64
    %DATA CUT
    

end

L3=length(data(3).time);cut=L3;
L1=length(data(1).time);
L2=length(data(2).time);
if  modal.tcut<data(3).time(L3)
    cut=find(data(3).time>modal.tcut,1);
end
if L3>L2
    zero=find(data(2).data==0,1);
    %data(1).data(zero:L3,:)=data(1).data(zero-1,:);
    %data(2).data(zero:L3,:)=data(2).data(zero-1,:);
    data(1).data(L2:L3,:)=0;
    data(2).data(L2:L3,:)=0;
end
data(2).data=data(2).data(1:cut,:);
data(3).data=data(3).data(1:cut,:);
data(2).time=data(3).time(1:cut);
data(3).time=data(3).time(1:cut);
    


for i=modal.glob(1):modal.glob(2)
    
    
    %What to plot
    data(i).plot=data(i).data;
    
    %%%% Normalisation
    
    for j=modal.pow(1):modal.pow(2)
        maxt=find(data(i).plot(:,j)==max(data(i).plot(:,j)),1); %maximum
        maxtl=maxt-0; maxtu=maxt+0;
        if i==3  % B transients (unq=1, quench=2)
            % Select max on UC peak (not laser artefact)
            tpost=find(data(i).time>1.0E-8);
            maxt=find(data(i).plot(:,j)==max(data(i).plot(tpost,j)),1); %maximum
            maxtl=maxt-0; maxtu=maxt+50/modal.binsize;
        end
        data(i).meanmax(j)=mean(data(i).plot(maxtl:maxtu,j)); % make an average of the 0 points after the maximum
    end
end %maxmaxt=round(mean(maxt(1,:))); %ATTENTION HERE CHNAGED maxt(1,:)
for i=modal.glob(1):modal.glob(2)
    
    
    for j=modal.pow(1):modal.pow(2)
        data(i).fito(:,j)=data(i).plot(:,j); %use the shortest time range as universal, 
        data(i).fitn(:,j)=data(i).fito(:,j)/data(i).meanmax(j); %same with normalize to average of maximum+10
        data(i).t=data(i).time; %time cut into same period
        %tl(i)=length(data(i).t);
    end
end

for i=modal.glob(1):modal.glob(2)
final(i).t=data(i).t;
final(i).irf=data(i).irf;
final(i).max=data(i).meanmax;
final(i).m(1:cut,1:l)=0;
final(i).c(1:cut,1:l)=0;
final(i).power=data(i).power;
    switch modal.norm %norm=0, choose original data fito, norm=1 choose normalized data
        case 0
            final(i).d=data(i).fito; %3dimentsional array for final fittable data
        case 1
            final(i).d=data(i).fitn; %3dimentsional array for final fittable data
end
end

end
