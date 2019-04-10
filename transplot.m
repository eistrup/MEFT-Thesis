function transplot(data,T,xfit,m)
close all

t_1=1;
t_2=10;
t_3=100;
t_4=1000;
t_5=7000;
t_vect=[t_1,t_2,t_3,t_4,t_5];

if m.cross==1    %POPULATIONS CROSS SECTION
    treal=importdata('./write/treal.dat');
    cross_n=importdata('./write/cross_n_P7.dat');
    cross_p=importdata('./write/cross_p_P7.dat');
    cross_t=importdata('./write/cross_t_P7.dat');
    cross_h=importdata('./write/cross_h_P7.dat');
end

 %Plotting the results,
 %Plotting
 %marker_mod(1:4,:)=[('- ');('--');(': ');('--');];
 marker_mod(1:4,:)=[('- ');('- ');('-.');('--');];
 
 marker_size=50;
 marker_size_A=5;
 
 line_width_A=1;
 line_width_B=2;
 
 marker_dat(1:4,:)=[('s ');('o ');('s ');('* ');];
 width(1:4)=[5,5,10,1];
 trans1=1;
 %colors1(1:7,:)=[[0.5 0.5 0.5];[0.5 0 0.5];[0.2 0.2 0.2];[0.6 0.6 0.6];[0.7 0.4 1];[0.4 0.7 1];[0.3 0.3 1];];
 a=14;b=60;c=83;abc=(a+b+c)*1.6;
 a=a/abc;b=b/abc;c=c/abc;
 color1(1,:)=[a b c];
 a=21;b=147;c=185;abc=(a+b+c)*0.8;
 a=a/abc;b=b/abc;c=c/abc;
 color1(2,:)=[a b c];
 a=237; b=108;c=43;abc=(a+b+c)*0.8;
 a=a/abc;b=b/abc;c=c/abc;
 color1(3,:)=[a b c];
 
 a=a/abc;b=b/abc;c=c/abc;
 colors1(1:7,:)=[[0.5 0.5 0.5];[0.5 0 0.5];[0.2 0.2 0.2];[0.6 0.6 0.6];color1(1,:);color1(2,:);color1(3,:);];
 trans2=1;
 colors2(1:7,:)=[[0 0 0];[0 0 0];[0 0 0];[0 0 0];[0 0 0];[0 0 0];[0 0 0];];
 
 
        t0=find(data(3).irf==max(data(3).irf),1); %find IRF start/max
        data(2).t=data(2).t-data(2).t(t0); %set that t0 as start point
        data(3).t=data(3).t-data(3).t(t0); %set that t0 as start point
 
        
 %for i=m.pow(1):m.pow(2)
 %    data(3).d(ts:end,i)=smooth(data(3).d(ts:end,i));
 %    data(3).d(ts2:end,i)=smooth(data(3).d(ts2:end,i));
 %    data(3).d(ts2:end,i)=smooth(data(3).d(ts2:end,i));
 %end
 tA=find(data(3).t>0.3*10^-7,1);
 tB=find(data(3).t>10^-7,1);
 tC=find(data(3).t>3*10^-7,1);
 tD=find(data(3).t>1*10^-6,1);
 
 i=7;
 switch m.plot
     case 1
        %subplot(2,2,1);
        %A loglog
        yyaxis left;j=2;
        s1(i)=semilogy(data(j).t,data(j).d(:,i),marker_dat(j,:),'MarkerSize',marker_size_A,'MarkerEdgeColor',colors1(i,:));hold on;
        h1(i)=plot(data(3).t,data(j).c(:,i), marker_mod(j,:),'Color',colors2(i,:),'Linewidth',line_width_A); hold on;
        axis([10^-9 8000*10^-9 0 1.1]); %linlin
        set(gca,'ycolor',[0 0 0]);set(gca, 'FontName', 'Arial')        
        set(gca,'yscale','log');set(gca,'xscale','log');
        %B loglog
        yyaxis right;j=3;         
        semilogy(data(j).t,data(j).d(:,i)*data(j).max(i)/data(j).max(7),marker_dat(j,:),'MarkerSize',marker_size_A,'MarkerEdgeColor',colors1(i,:));hold on;
        %step=1;semilogy(data(j).t(1:step:tA),data(j).d(1:step:tA,i)*data(j).max(i)/data(j).max(7),marker_dat(j,:),'MarkerSize',marker_size_A,'MarkerEdgeColor',colors1(i,:));hold on;
        %step=5;semilogy(data(j).t(tA:step:tB),data(j).d(tA:step:tB,i)*data(j).max(i)/data(j).max(7),marker_dat(j,:),'MarkerSize',marker_size_A,'MarkerEdgeColor',colors1(i,:));hold on;
        %step=10;semilogy(data(j).t(tB:step:tC),data(j).d(tB:step:tC,i)*data(j).max(i)/data(j).max(7),marker_dat(j,:),'MarkerSize',marker_size_A,'MarkerEdgeColor',colors1(i,:));hold on;
        %step=50;semilogy(data(j).t(tC:step:tD),data(j).d(tC:step:tD,i)*data(j).max(i)/data(j).max(7),marker_dat(j,:),'MarkerSize',marker_size_A,'MarkerEdgeColor',colors1(i,:));hold on;
        %step=100;semilogy(data(j).t(tD:step:end),data(j).d(tD:step:end,i)*data(j).max(i)/data(j).max(7),marker_dat(j,:),'MarkerSize',marker_size_A,'MarkerEdgeColor',colors1(i,:));hold on;
        h2(i)=semilogy(data(3).t,data(j).c(:,i)*data(j).max(i)/data(j).max(7),marker_mod(j,:),'Color',colors2(i,:),'Linewidth',line_width_B); hold on;
        set(gca,'ycolor',[0 0 0]);set(gca, 'FontName', 'Arial')
        set(gca,'yscale','log');set(gca,'xscale','log');

        D=data(j).c(end,i)*data(j).max(i)/data(j).max(7);line([8*10^-10 10^-5],[D D])
        
        yyaxis left; axis([8*10^-10 10^-5 10^-3 1.5])
        yyaxis right; axis([8*10^-10 10^-5 10^-1 1.5])
        yyaxis left; ylabel('Photoluminesce');xlabel('Time (s)');
        
        for n=1:5
            yyaxis left;
            line([t_vect(n)*10^-9 t_vect(n)*10^-9],[10^-10 10^20],'Color',[0.7 0.7 0.7]);    
        end

 
     case 2
        %subplot(2,2,2);
        %B linlin
        yyaxis right;j=3;
        %[tb,db]=binning(data(j).t,data(j).d(:,i),1);db=db/max(db);
        %scatter(tb,db*data(j).max(i)/data(j).max(7),marker_size,marker_dat(j,:),'MarkerEdgeColor',colors1(i,:),'MarkerEdgeAlpha',trans1); hold on;
        scatter(data(j).t,data(j).d(:,i)*data(j).max(i)/data(j).max(7),marker_size,marker_dat(j,:),'MarkerEdgeColor',colors1(i,:),'MarkerEdgeAlpha',trans1); hold on;
        loglog(data(3).t,data(j).c(:,i)*data(j).max(i)/data(j).max(7),marker_mod(j,:),'Color',colors2(i,:),'Linewidth',line_width_B); hold on;
        set(gca,'xscale','lin');set(gca,'yscale','lin');
        set(gca,'ycolor',[0 0 0]); set(gca, 'FontName', 'Arial')
        set(gca,'ytick',[0.2, 0.4, 0.6, 0.8 , 1.0, 1.2, 1.4])
        set(gca,'yticklabel',[0.2, 0.4, 0.6, 0.8 , 1.0, 1.2, 1.4])
        yyaxis left;
        set(gca,'ytick',[0.2, 0.4, 0.6, 0.8 , 1.0, 1.2, 1.4])
        set(gca,'yticklabel',[0.2, 0.4, 0.6, 0.8 , 1.0, 1.2, 1.4])
        set(gca,'ycolor',[0 0 0]); set(gca, 'FontName', 'Arial')
        
        yyaxis left; axis([-10^-7 0.81*10^-5 10^-4 1.5])
        yyaxis right; axis([-10^-7 0.81*10^-5 10^-4 1.5])
        
        for n=1:5
            yyaxis left;
            line([t_vect(n)*10^-9 t_vect(n)*10^-9],[10^-10 10^20],'Color',[0.7 0.7 0.7]);    
        end


     case 3
        %subplot(2,2,3);
        for i=m.pow(1):m.pow(2)
            %A loglin
            yyaxis left;j=2;
            plot(data(j).t,data(j).d(:,i),marker_dat(j,:),'MarkerSize',marker_size_A,'MarkerEdgeColor',colors1(i,:));hold on;
            plot(data(3).t,data(j).c(:,i),marker_mod(j,:),'Color',colors2(i,:),'Linewidth',line_width_B); hold on;
            set(gca,'xscale','lin');set(gca,'yscale','log');
            set(gca,'ycolor',[0 0 0]);set(gca, 'FontName', 'Arial');
            %B loglin
            yyaxis right;j=3;
            plot(data(j).t,data(j).d(:,i)*data(j).max(i)/data(j).max(7),marker_dat(j,:),'MarkerSize',marker_size_A,'MarkerEdgeColor',colors1(i,:));hold on;
            plot(data(3).t,data(j).c(:,i)*data(j).max(i)/data(j).max(7),marker_mod(j,:),'Color',colors2(i,:),'Linewidth',line_width_B); hold on;
            set(gca,'xscale','lin');set(gca,'yscale','log');
            set(gca,'ycolor',[0 0 0]);set(gca, 'FontName', 'Arial');
            yyaxis left; axis([8*10^-10 110*10^-9 10^-3 1.1]);
            yyaxis right; axis([8*10^-10 110*10^-9 10^-2 1.1]);
  
        end
 %legend('5 uW','10uW','15uW','Data', 'Model','MAPI PL','Upconversion','0','0','0','0','0','0');
        for n=1:5
            yyaxis left;
            line([t_vect(n)*10^-9 t_vect(n)*10^-9],[10^-10 10^20],'Color',[0.7 0.7 0.7]);    
        end
        legend('5 uW','10uW','15uW','Data', 'Model','MAPI PL','Upconversion','0','0','0','0','0','0');


     case 4 %POPULATIONS AT INTERFACE
        %subplot(2,2,4)
        treal=data(3).t;
        
        loglog(data(3).t,cross_n(:,m.L1),'-','Linewidth',2,'Color',[1 0 0]);hold on;
        loglog(data(3).t,cross_p(:,m.L1),':','Linewidth',2,'Color',[0.6 0 0]);
        loglog(data(3).t,cross_t(:,1),'-','Linewidth',2,'Color',[0 0 1]);
        loglog(data(3).t,cross_h(:,1),':','Linewidth',2,'Color',[0 0 0.6]);
        set(gca,'yscale','log');
        ylabel('Interface density (cm^{-3})');
        ylim([1E10 1E20]);
        xlim([8E-10 10E-6]);
        
        yyaxis right;hold on;
        plqe=importdata(strcat('./write/plqe_P',num2str(i),'.dat'));
        
        full_abs=sum(cross_n(1,:))*m.d1;
        line([1E-10 1E-5],[full_abs full_abs],'LineStyle','--','Linewidth',1,'Color',[0.5 0.5 0.5]);hold on; %7=n_abs

        loglog(treal,cumsum(plqe(:,2)),'-','Linewidth',2,'Color',[0.5 0.5 0.5]); %n loss
        loglog(treal,cumsum(plqe(:,5)),':','Linewidth',2,'Color',[0.5 0.5 0.5]); %h loss
        loglog(treal,cumsum(plqe(:,1)),'-.','Linewidth',2,'Color',[0.5 0.5 0.5]); %rad loss
        loglog(treal,cumsum(plqe(:,3)*10),'-','Linewidth',4,'Color',[1 0.5 0.5]); %TG
        x=cumsum(plqe(:,3));
        x(1)
        x(end)
        loglog(treal,cumsum(plqe(:,4)*10^4),'-','Linewidth',4,'Color',[0.5 0.5 1]); %TF
        text(1.1*10^-8,1*10^13,'x10','Color',[1 0.5 0.5]);
        text(1.1*10^-8,0.25*10^13,'x10^4','Color',[0.5 0.5 1]);
        set(gca,'YColor',[0.5 0.5 0.5]);
        set(gca,'yscale','lin');
        ylabel('Accumulated Population (cm^{-2})');
        
        for n=1:5
            yyaxis right;
            line([t_vect(n)*10^-9 t_vect(n)*10^-9],[0 4*10^13],'Color',[0.7 0.7 0.7]);
        end
        yyaxis right; axis([2*10^-10 0.81*10^-5 0 3.5*10^13]);
        legend('Interface-MAPI electrons','Interface-MAPI holes','Interface-Rubrene triplets','Interface-Rubrene holes','Absorbed photons','MAPI electron loss','MAPI hole loss','Radiative loss','Triplet Generation','Triplet Fusion')
        
 end

if m.cross==1    %POPULATIONS CROSS SECTION
    t=importdata('./write/treal.dat');
    t1=1; %original excitation profile
    t2=find(t>t_2*10^-9,1); % build-up regime
    t3=find(t>t_3*10^-9,1); % 1st very fast decay
    t4=find(t>t_4*10^-9,1); %2nd fast decay
    t5=find(t>t_5*10^-9,1); % 3rd slow decay
    tvect=[t1,t2,t3,t4,t5];
    color_n=[1 0 0];
    color_p=[0.6 0 0];
    color_t=[0 0 1];
    color_h=[0 0 0.6];
    width=4;
    pos=[0.8*10^13,0.8*10^13,0.5*10^13,10^14,10^15];
    z1=linspace(0,m.H1,m.L1);
    z2=linspace(0,m.L2,m.L2);
    figure;
    for i=1:5
    %MAPI side
    subplot(5,1,i);
    yyaxis right;
    semilogy(z1,cross_n(tvect(i),1:end),'-','Color',color_n,'Linewidth',width);hold on; %plot electron population
    semilogy(z1,cross_p(tvect(i),1:end),':','Color',color_p,'Linewidth',width);hold on; %plot electron population
    %RUBRENE side
    semilogy((z2+m.H1),cross_t(tvect(i),1:end),'-','Color',color_t,'Linewidth',width);
    semilogy((z2+m.H1),cross_h(tvect(i),1:end),':','Color',color_h,'Linewidth',width);
    line([z1(end) z1(end)],[10^5 10^20],'Color',[0 0 0 1]);%border/interface line
    axis([4*10^-5 6*10^-5 10^5 10^19]);
    text(4.2*10^-5, pos(i), strcat('t_',num2str(i),'=',num2str(t_vect(i),4),'ns'),'FontName','Arial');
    set(gca,'YColor','k')
    set(gca,'xtick',[0*10^-5,1*10^-5,2*10^-5,3*10^-5,4*10^-5,5*10^-5,6*10^-5])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[10^6, 10^10, 10^14, 10^18])
    set(gca,'yticklabel',[])
    set(gca,'YMinorTick','off')
    yyaxis left;
    axis([4*10^-5 6*10^-5 10^5 10^19]);
    set(gca,'YColor','k')
    set(gca,'yscale','log')
    set(gca,'ytick',[10^6, 10^10, 10^14, 10^18])
    set(gca,'yticklabel',[])
    set(gca,'YMinorTick','off')
    end
    yyaxis right;
    set(gca,'FontName','Arial')
    set(gca,'xtick',[0*10^-5,1*10^-5,2*10^-5,3*10^-5,4*10^-5,5*10^-5,6*10^-5])
    set(gca,'xticklabel',[0,100,200,300,400,500,600])
    %set(gca,'YAxisLocation','right');
    xlabel('Vertical coordinate z (nm)');
    subplot(5,1,3); yyaxis right;
    ylabel('Population density (cm^{-3})');
    subplot(5,1,1); yyaxis right;
    %set(gca,'yticklabel',[['10^{12}'],['10^{14}'],['10^{16}'],['10^{18}']])
    set(gca,'yticklabel',{'10^{12}','10^{14}','10^{16}','10^{18}'})
    text(5.1*10^-5, 10^20, 'Rubrene','Color',color_h);
    text(4.5*10^-5, 10^20, 'MAPI','Color',color_p);
    legend('MAPI electrons','MAPI holes','Rubrene triplets','Rubrene holes');
end

end



% style_mod(:,:,1)=[('- k');('- b');('- c');('- m');('- r');('- g');('- y');('- k');('- b');('--m');('--m');('--c');('--c');];
%  style_mod(:,:,2)=[('-.k');('-.b');('-.c');('-.m');('-.r');('-.g');('-.y');('-.k');('-.b');('-.m');('-.m');('-.c');('-.c');];
%  style_mod(:,:,3)=[('--k');('--b');('--c');('--m');('--r');('--g');('--y');('--k');('--b');('--m');('--m');('--c');('--c');];
%  style_mod(:,:,4)=[(': k');(': b');(': c');(': m');(': r');(': g');(': y');(': k');(': b');(': m');(': m');(': c');(': c');];
%  style_dat(:,:,1)=[('s k');('s b');('s c');('s m');('s r');('s g');('s y');('s k');('s b');('s m');('s m');('s c');('s c');];
%  style_dat(:,:,2)=[('o k');('o b');('o c');('o m');('o r');('o g');('o y');('o k');('o b');('o m');('o m');('o c');('o c');];
%  style_dat(:,:,3)=[('x k');('x b');('x c');('x m');('x r');('x g');('x y');('x k');('x b');('x m');('x m');('x c');('x c');];
%  style_dat(:,:,4)=[('* k');('* b');('* c');('* m');('* r');('* g');('* y');('* k');('* b');('* m');('* m');('* c');('* c');];
%legend('A unq 5uW','A unq 5uW model','A que 5uW','A que 5uW model','B 5uW','B 5uW model', 'A unq 10uW','A unq 10uW model','A que 10uW','A que 10uW model','B 10uW','B 10uW model','A unq 15uW','A unq 15uW model','A que 15uW','A que 15uW model','B 15uW','B 15uW model')

