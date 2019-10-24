
d=load('dataset_2.dat'); %Loading the dataset
m=500;
k=0;

for l=1:m
    for i=1:2
        for j=1:length(d)
            if d(j,i) == l;
                k(j)= d(j,3);
            end
            deg(l) = sum(k);
        end
    end
    k = 0;
end

%To form adjacency matrix a

%Upper triangle of adjacency matrix
b1(m,m)=0;

for i=1:length(d)
    for i1=1:m
        for j1=1:m
            if d(i,1) == i1 && d(i,2) == j1
                b1(i1,j1) = d(i,3);
            end
        end
    end
end

b2=b1.';

a=b1+b2;
d1=diag(deg);

%To find Lsymmetric
% ls=((d1).^(-1/2)).*(a).*((d1).^(1/2));
% ls=((d1).^(-1/2))*(a)*((d1).^(1/2));

lap=d1-a;
%lap=inv(d1).*lap1;
%Below command needs some time to get evaluated
[x,e]=eig(lap);
e1=diag(e);

%I'm using Eigen-Gap heuristic for deciding 'k' 
clear k; k=32;
x1=x(:,1:k);

clear i;

for i=1:m
    x2(i)=(sum(x1(i,:).^2)).^(1/2);
end

x3=x2.';

clear i;clear j;

for i=1:m
    for j=1:k
        y(i,j)=((x1(i,j))/x3(i));
    end
end

id=kmeans(y,k); %K-means algorithm

c = deg.' ; %x matrix
ea = eig(a); %eigenvalues of a
l = max(ea); %Largest eigenvalue = lambda
ecv = (a * c)/l; %Eigenvector Centrality values

%To find sum of eigenvector centrality of nodes belonging to each clusters
clear i;clear j;

ecs=0;r=0;

for i=1:k
    for j=1:500
        if id(j)==i
            ec= ecv(j);
            ecs=[ecs ec];
        end
    end
    r(i)=sum(ecs);
    ra(i)=mean(ecs);
    rs(i)=sqrt(var(ecs));
end

ra1=ra.';
figure(1)
plot(r)
grid on;

figure(2)
plot(ra)
grid on;

figure(3)
plot(rs)
grid on;