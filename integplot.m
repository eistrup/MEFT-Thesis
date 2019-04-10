function integplot(integ,dinteg, experimental)
 a=14;b=60;c=83;abc=(a+b+c)*1.6;a=a/abc;b=b/abc;c=c/abc;color1(2,:)=[a b c];
 a=21;b=147;c=185;abc=(a+b+c)*0.8; a=a/abc;b=b/abc;c=c/abc;color1(3,:)=[a b c];
 a=237; b=108;c=43;abc=(a+b+c)*0.8;a=a/abc;b=b/abc;c=c/abc;color1(4,:)=[a b c];

color1(1,:)=[0.3 0.3 0.3];
marker1=['o'];
%color1=['m'];


factor=100;

close;
yyaxis left;
loglog(integ.Epd, integ.nabs,'-','Color',[0.2, 0.2, 0.2],'LineWidth',0.1);hold on; % Absorbed Photon density
loglog(integ.Epd, integ.rad,'-.k');hold on; % Radiative Decay
loglog(integ.Epd, integ.nonrad,'--k');hold on; % Non Radiative Decay
loglog(integ.Epd, integ.triplet,'--','Color',color1(3,:),'LineWidth',2);hold on; % Triplet population /transfer
loglog(integ.Epd, integ.singlet,'-','Color',color1(3,:),'LineWidth',2);hold on; % Singlet population /UC emission
loglog(dinteg.Epd,dinteg.UC,marker1,'Markersize',10,'Color',color1(3,:));hold on;
    
ylabel('Number (cm^{-2})');
set(gca,'yscale','log');

yyaxis right;
loglog(integ.Epd, integ.plqe*100,'- k','LineWidth',2);hold on; %PLQE
loglog(integ.Epd, integ.tg*100*factor,'--', 'Color', color1(4,:),'LineWidth',2);hold on; %TETE
loglog(integ.Epd, integ.tf*100/10,'-.', 'Color', color1(4,:),'LineWidth',2);hold on; %TFE
%loglog(integ.Epd, integ.uce1*100*factor,'- b','LineWidth',10);hold on; %UCE
loglog(integ.Epd, integ.uce2*100*factor,'-','Color', color1(4,:),'LineWidth',4);hold on; %UCE
loglog(dinteg.Epd,dinteg.UCE*100*factor,marker1,'Markersize',10, 'Color', color1(4,:),'MarkerFaceColor',color1(4,:));

set(gca,'yscale','lin');
ylabel('Efficiency (%)')

legend('Absorbed Photons','Radiative Loss','Non-Radiative Loss','Triplets (TG)','Singlets (TF)','UC data','PL Efficiency ','TG Efficiency','TF Efficiency','UC Efficiency','UCE data');

yyaxis left;
    set(gca,'ycolor',[0 0 0])
    set(gca, 'FontName', 'Arial')
    axis([0.6*10^-7 10^-4 10^4 10^15]);
    
yyaxis right;
    set(gca,'ycolor',[0 0 0])
    set(gca, 'FontName', 'Arial')
    axis([0.6*10^-7 10^-4 0 10]);
    
    xlabel('Excitation Energy (J cm^{-2})')



end