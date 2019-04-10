
function [dd]=simfit(x,T,data,m,fitplot) %fitplot=1, fit %fiplot=0, plot
%FUNCTION THAT RUNS ALL Nph0 INTO model AND FITS WITH THE SUM OF OUTPUTS d
%x are parameter-vector to be fitted (K1,K2)

li=m.pow(2)-m.pow(1)+1;


%parfor k=1:ij %par is faster than normal for i + for j
tic
if m.par==0
    for i=m.pow(1):m.pow(2) %par is faster than normal for i + for j
        m.tl=length(data(3).t(:)); %length of time data
        m.h0=data(3).t(2)-data(3).t(1); %step/spacing of time data
        %CALL THE MODEL
        model(x,T,data(3).power(i),[i,3],m); %last parameter is flag     
        mod=importdata(strcat('./write/plqe_P',num2str(i),'.dat'));
        
        convo=conv(mod(:,4),data(3).irf,'full'); %convolve the data with corresponding IRF
        convo=convo(1:m.tl);%cut result from convolution into size of original data
        data(3).c(:,i)=convo/(1-m.norm+m.norm*max(convo));%normalizing it
        
        convo=conv(mod(:,1),data(3).irf,'full'); %convolve the data with corresponding IRF
        convo=convo(1:m.tl);
        data(2).c(:,i)=convo/(1-m.norm+m.norm*max(convo));%normalizing it
        
        %data(2).d(length(data(2).t):m.tl)=0;
        

        
%          triplet=importdata('data_UC_7.dat');
%          triplet=triplet(:,2).^2;
%          convo=conv(triplet,data(3).irf,'full'); %convolve the data with corresponding IRF
%          convo=convo(1:m.tl);
%          data(3).triplet=convo/(1-m.norm+m.norm*max(convo));%normalizing it

        
        
        if m.fit==1 || m.fit==3     %Determine LOSS "d" to real data
            %d1(i)=sum(((data(2).c(:,i)-data(2).d(:,i)).^2)./data(2).c(:,i))
            d1(:,i)=0;
            d2(:,i)=((data(3).c(:,i)-data(3).d(:,i)).^2)./data(3).d(:,i);
            %d2(i)=0;
            d(i)=sum(d1(:,i))+sum(d2(:,i));
        end
    end
elseif m.par>0
    for i=m.pow(1):m.pow(2) %par is faster than normal for i + for j
        m.tl=length(data(3).t(:)); %length of time data
        h0=data(3).t(2)-data(3).t(1); %step/spacing of time data
        %CALL THE MODEL
        mod=model(x,T,power(i),[i,3],m.tl,h0,m,m); %last parameter is flag     
        if m.out==2
            mod=importdata(strcat('data_J',num2str(j),'_P',num2str(i),'.dat'));
            disp('Model out=2')
        end
        
        convo3=conv(mod(:,2),data(3).irf,'full'); %convolve the data with corresponding IRF
        convo3=convo3(1:m.tl);%cut result from convolution into size of original data
        convo3=convo3/(1-m.norm+m.norm*max(convo3));%normalizing it
        
        convo2=conv(mod(:,1),data(3).irf,'full'); %convolve the data with corresponding IRF
        convo2=convo2(1:m.tl);
        convo2=convo2/(1-m.norm+m.norm*max(convo2));%normalizing it
        
        data(2).d(length(data(2).t):m.tl)=0;
        
        if m.fit==1     %Determine LOSS "d" to real data
            d2(i)=sum(((convo2-data(2).d(:,i)).^2)./data(2).d(:,i));
            d3(i)=sum(((convo3-data(3).d(:,i)).^2)./data(3).d(:,i));
            d(i)=d2(i)+d3(i);
            %d(i)=d3
        end
    end
end
        
toc
if m.fit==1
    x
    dd=sum(d(:))
    
elseif m.fit==0 %just plot the convolved model
    dd=data;           
end


end