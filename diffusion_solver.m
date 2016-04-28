function phi=diffusion_solver(n,hx,hy,D,sigma,S,tolerance)

%FINDING VALUES FOR 5-POINT DIFFERENCE

Ac=zeros(n,n);
Al=zeros(n,n);
Ar=zeros(n,n);
At=zeros(n,n);
Ab=zeros(n,n);
for i=1:n-1
    for j=1:n-1
        Al(i,j)=-(D(i,j)+D(i,j+1))*hy/(2*hx);
        Ar(i,j)=-(D(i+1,j)+D(i+1,j+1))*hy/(2*hx);
        Ab(i,j)=-(D(i,j)+D(i+1,j))*hy/(2*hx);
        At(i,j)=-(D(i,j+1)+D(i+1,j+1))*hy/(2*hx);
        Ac(i,j)=sigma(i,j)-(Al(i,j)+Ar(i,j)+At(i,j)+Ab(i,j));
    end   
end

%BOUNDARY CONDITIONS

for i=1:n-1
    Ar(i,1)=0;
    At(i,1)=0;
    Al(i,1)=0;
    Ac(i,1)=S(i,1)-Ab(i,1);
    
    Ar(1,i)=0;
    At(1,i)=0;
    Ab(1,i)=0;
    Ac(1,i)=S(1,i)-Al(1,i);
   
    Al(i,n)=-D(i,n)*hy/(2*hx);
    Ar(i,n)=-D(i+1,n)*hy/(2*hx);
    At(i,n)=0;
    Ac(i,n)=sigma(i,n)-(Al(i,n)+Ar(i,n)+At(i,n)+Ab(i,n));
    At(n,i)=-D(n,i+1)*hy/(2*hx);
    Ab(n,i)=-D(n,i)*hy/(2*hx);
    Ar(n,i)=0;
    Ac(n,i)=sigma(n,i)-(Al(n,i)+Ar(n,i)+At(n,i)+Ab(n,i));
end

%CORNER CONDITIONS
    
Ar(1,1)=0;
At(1,1)=0;
Al(1,1)=-(D(1,1)+D(1,2))*hy/(2*hx);
Ab(1,1)=-(D(1,1)+D(2,1))*hy/(2*hx);
Ac(1,1)=S(1,1)-Ab(1,1)-Al(1,1);
    
At(n,n)=0;
Ac(n,n)=sigma(n,n)-(Al(n,n)+Ar(n,n)+At(n,n)+Ab(n,n));

%CREATING A AND S

A=zeros(n^2,n^2);
s=zeros(n^2,1);
for i=1:n
    for j=1:n
        s(n*(i-1)+j)=S(i,j);
        A(j+n*(i-1),j+n*(i-1))=Ac(i,j);
        if j~=n
            A(j+n*(i-1),j+n*(i-1)+1)=Ar(i,j);
            A(j+n*(i-1)+1,j+n*(i-1))=Al(i,j);
        end
    end
    if i~=n
        for j=1:n
            A(j+n*(i-1),j+n*(i))=At(i,j);
            A(j+n*(i),j+n*(i-1))=Ab(i,j);
        end
    end
    s(i)=0.5*S(1,i);
    s(n*(i-1)+1)=0.5*S(i,1);
end

%SUCCESSIVE OVER-RELAXATION SOLVER

phi=zeros(n^2,1);
phiprev=phi;
tol=intmax;
w=1.1;
while tol>tolerance
    for i=1:n^2
        phi(i)=(1-w)*phiprev(i)+(w/A(i,i))*(s(i)-A(i,[1:i-1])*phi([1:i-1])-A(i,[i+1:n^2])*phiprev([i+1:n^2]));
    end
    tol=abs(max(phi-phiprev));
    phiprev=phi;
end

%PLOTTING THE OUTPUT

x=zeros(n);
y=zeros(n);
z=zeros(n,n);
for i=1:n
    for j=1:n
        x(i,j)=(i-1)*hx;
        y(i,j)=(j-1)*hy;
        z(i,j)=phi(n*(i-1)+j);
    end
end
phi=z;
surf(x,y,phi);
end