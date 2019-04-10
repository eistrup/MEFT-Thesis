%BINNING PROCESs
function [tt,datbin]=binning(ti,data,binsize)
tl=length(ti);
l=length(data(1,:));
k=0; 
tlbin=(floor(tl/binsize));
ttl=tlbin*binsize;
datbin(1:tlbin,1:l)=0;
tt=ti(1:binsize:ttl);
for i=1:l
        for j=1:binsize:ttl-binsize
            k=k+1;
            datbin(k,i)=sum(data(j:j+binsize-1,i)); %Binned
        end
        k=0;
end
end