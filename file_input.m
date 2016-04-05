function [n,hx,hy,tolerance,D,sigma,S]=file_input(filename)
format long
fID=fopen(filename,'r');
file=fscanf(fID,'%f');
n=file(1);

if length(file)>(n^2)*3+4
    error('Too much data provided');
elseif length(file)<(n^2)*3+4
    error('Not enough data provided');
end

hx=file(2);
hy=file(3);
tolerance=file(4);

D=ones(n,n);
sigma=ones(n,n);
S=ones(n,n);

for i=1:n
    for j=1:n
        Dval=file((i-1)*n+j+4);
        sigmaval=file((i-1)*n+j+4+n^2);
        Sval=file((i-1)*n+j+4+2*(n^2));
        if Dval<0
            error('Values for D cannot be negative');
        elseif sigmaval<0
            error('Values for sigma cannot be negative');
        elseif Sval<0
            error('Values for S cannot be negative');
        end
        D(i,j)=Dval;
        sigma(i,j)=sigmaval;
        S(i,j)=Sval;
    end
end
end