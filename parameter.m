function [output]=parameter(T,xfit,norm,option)

L1=length(table2array(T(:,1))); j=1;

switch option
    case 0 %set values fixed&fit for model
        vars=cell(L1,2);
        for i=1:L1
            vars(i,1)=table2cell(T(i,1));%name of variable
            if table2array(T(i,4))==0 %looking at fitp vector/column
                vars(i,2)=num2cell(table2array(T(i,2))*table2array(T(i,3))); %Fixed value x factor
            elseif table2array(T(i,4))==1
                vars(i,2)=num2cell(xfit(j)*table2array(T(i,3))); %fitting value x factor
                j=j+1;
            end
        end
        varst=vars';
        p=struct(varst{:});
        
        %Given Parameters
        KbT=0.025; %Thermal Energy (eV) if divided by q gives 0.025V !!!
        %Thermionic emission terms for transfer rate
        p.Texp(1)=exp(-p.WCB/KbT); %CB to Trap State
        p.Texp(2)=exp(-p.WVB/KbT); %VB to HOMO
        %KTTA and KTCA calculated with DTE and Dp from Baldo et al. 
        
        %p.KTTA=8*pi()*p.Rc*(p.DTE); %KTTA dependent on DTE only
        %p.KTCA=4*pi()*p.Rc*(p.DTE+p.Dh); %KTCA dependent on DTE and Dh
        %p.KTCA=;
        
        %p.KTTA
        output=p;

    case 1 %set values for fit vector x
        for i=1:L1
            if table2array(T(i,4))==1
                output(j,1)=table2array(T(i,2)); %Fit parameters start
                output(j,2)=table2array(T(i,5)); %fit parameters lower
                output(j,3)=table2array(T(i,6)); %fit parameters upper
                j=j+1;
            end
        end

    case 2 %output fitted values
        L2=length(xfit);
        vars=cell(L2,2);
        for i=1:L1
            if table2array(T(i,4))==1
                vars(j,1)=table2cell(T(i,1));%name of variablej=j+1;
                vars(j,2)=num2cell(xfit(j)*table2array(T(i,3)));%fitted value x factor
                j=j+1;
            end
        end
        varst=vars';
        output=struct(varst{:});
        
    case 3 %output fitted value in text string array
      %  L2=length(xfit);j=1;
        for i=1:L1
            if table2array(T(i,4))==1
                txt=strcat(char(table2cell(T(i,1))),'=',num2str(double(xfit(j)*table2array(T(i,3))),4));
                switch norm
                    case 0
                        pos0=table2array(T(13,2))*table2array(T(13,3));
                        pos=pos0*exp(-(j+1)*0.6);  text(100*10^-9,pos,txt);
                    case 1
                        pos=1*exp(-(j+1)*0.6);  text(200*10^-9,pos,txt);
                end
                j=j+1;
            end
        end
        output=0;
    end
end
