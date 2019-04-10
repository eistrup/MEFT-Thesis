function [fileID]=writer(mode,fileID,plqe,niter1,niter2,treal,power,ipower,jglob,m)
    switch mode
        case 0 %start files
            filename=strcat('./write/plqe_P',num2str(ipower),'.dat'); %open file
            fileID.pl = fopen(filename,'wt'); %set type

            if m.cross==1
                filename=strcat('./write/treal.dat'); %open file
                fileID.treal = fopen(filename,'wt'); %set type
                filename_n=strcat('./write/cross_n_P',num2str(ipower),'.dat'); %open file
                filename_p=strcat('./write/cross_p_P',num2str(ipower),'.dat'); %open file
                filename_t=strcat('./write/cross_t_P',num2str(ipower),'.dat'); %open file
                filename_h=strcat('./write/cross_h_P',num2str(ipower),'.dat'); %open file
                fileID.n = fopen(filename_n,'wt'); %set type
                fileID.p = fopen(filename_p,'wt'); %set type
                fileID.t = fopen(filename_t,'wt'); %set type
                fileID.h = fopen(filename_h,'wt'); %set type
            end
                
        case 1 %write to files
            fprintf(fileID.pl,'%6.5E %6.5E %6.5E %6.5E %6.5E \n',[plqe(1),plqe(2),plqe(3),plqe(4),plqe(5)]); %write time iteration to file
            if m.cross==1
                fprintf(fileID.treal,'%6.5E \n',[treal]); %write time iteration to file
                for i=1:m.L1
                    fprintf(fileID.n,'%6.5E ',[niter1(i,1)]); %write time iteration to file
                    fprintf(fileID.p,'%6.5E ',[niter1(i,2)]); %write time iteration to file
                end
                for i=1:m.L2
                    fprintf(fileID.t,'%6.5E ',[niter2(i,1)]); %write time iteration to file
                    fprintf(fileID.h,'%6.5E ',[niter2(i,2)]); %write time iteration to file
                end
                fprintf(fileID.n,' \n'); %write time iteration to file
                fprintf(fileID.p,' \n'); %write time iteration to file
                fprintf(fileID.t,' \n'); %write time iteration to file
                fprintf(fileID.h,' \n'); %write time iteration to file
            end
            
        case 2 %close down files
            fclose(fileID.pl);
            if m.cross==1
                fclose(fileID.treal);
                fclose(fileID.n);
                fclose(fileID.p);
                fclose(fileID.t);
                fclose(fileID.h);
            end
            
        case 3 %write last_niter
            filename=strcat('./write/last_niter_',num2str(power),'.dat'); %open file
            fileID_last = fopen(filename,'wt'); %set type
            for i=1:m.L2
                fprintf(fileID_last,'%6.5E %6.5E \n',[niter2(i,1), niter2(i,2)]);        
            end
            fclose(fileID_last);
            
        case 4
            if m.cross==1;
                cross_t=importdata(strcat('./write/cross_t_P',num2str(ipower),'.dat'));
                triplet0=m.d2*sum(cross_t(1,:));
            else
                triplet0=0;
            end
            plqe=importdata(strcat('./write/plqe_P',num2str(ipower),'.dat'));
            filename=strcat('./write/power_',num2str(power),'.dat');
            fileID.power = fopen(filename,'wt'); %set type
%            d=[sum(plqe(:,1)); sum(plqe(:,2)); sum(plqe(:,3)); sum(plqe(:,4)); m.d2*sum(cross_t(1,:)); m.full_abs];
            d=[sum(plqe(:,1)); sum(plqe(:,2)); sum(plqe(:,3)); sum(plqe(:,4)); triplet0; m.full_abs];
             for i=1:length(d(:))
                   fprintf(fileID.power,'%6.5E \n',d(i));        
            end
            fclose(fileID.power);

    end
        
end
