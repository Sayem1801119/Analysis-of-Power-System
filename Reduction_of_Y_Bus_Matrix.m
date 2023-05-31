clc;
clear all
%First column of the excel file: Bus number
%Second column of the excel file: Bus number
%Transmission lines are connected between two buses
%Third column of the excel file:Line Resistance (pu)
%Fourth column of the excel file: Line Inductance (pu)
Directory=input('Please Enter the File Directory=','s');
Filename=input('Please Enter the File Name=','s');
cd(Directory) %To change the directory
A=xlsread(Filename) %To read the Excel file

B=A(:,[1:2]);
N=max(max(B)); %Finding the number Bus
L=size(A,1);
%Finding the impedance matrix
for i=1:L
    z(A(i,1),A(i,2))=A(i,3)+j*A(i,4);
    z(A(i,2),A(i,1))=z(A(i,1),A(i,2));
end
for i=1:N
    for j=1:N
        if z(i,j)==0
            z(i,j)=inf;
        end
    end
end
Z_Matrix=[z];
%Finding the node-to-node admittance
for i=1:N
    for j=1:N
        y(i,j)=1./(z(i,j));
    end
end
%Finding the Y_Bus matrix
for i=1:N
    for j=1:N
        if i==j
            Ybus(i,j)=sum(y(i,:));
        else
            Ybus(i,j)=-y(i,j);
        end
    end
end
disp('Y_Bus Matrix of the Given Power System:')
Y_Bus(v)=[Ybus]
r=input('How many bus reducted=')
for k=1:r
for i=1:N-r
    for j=1:N-r
        Yred(i,j)=Ybus(i,j)-((Ybus(i,N-k+1)*Ybus(N-k+1,j))/Ybus(N-k+1,N-k+1));
        Ybus(i,j)=Yred(i,j);
    end
end
end
Y_red(v)=[Yred]
