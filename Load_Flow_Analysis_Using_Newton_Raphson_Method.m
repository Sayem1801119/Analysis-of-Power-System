clc;
close all
clear all;
Directory=input('Please input the file directory','s');
%File 1
%First column of the excel file: Bus number
%Second column of the excel file: Bus number
%Transmission lines are connected between two buses
%Third column of the excel file:Line Resistance (pu)
%Fourth column of the excel file: Line Inductance (pu)
File1=input('Please input the file1','s');
%File 2
%Bus_1 is the slack bus (Reference bus)
%First column of the excel file: Bus number
%Second column of the excel file: Bus voltage (abs) in pu
%Third column of the excel file: Bus voltage angle (radian)
%Fourth column of the excel file: P_generated (pu)
%Fifth column of the excel file: Q_generated (pu)
%Sixth column of the excel file: P_load (pu)
%Seventh column of the excel file: Q_load (pu)
File2=input('Please input the file2','s');
cd(Directory)
A=xlsread(File1)
B=xlsread(File2)
tol=0.0000001;
Lm=size(A,1);
Nm=max(max(A));
for i=1:Lm
    z(A(i,1),A(i,2))=A(i,3)+1j*A(i,4);
     z(A(i,2),A(i,1))= z(A(i,1),A(i,2));
end
for i=1:Nm
    for j=1:Nm
        if z(i,j)==0
            z(i,j)=inf;
        end
    end
end
for i=1:Nm
    for j=1:Nm
        y(i,j)=1./z(i,j);
    end
end
for i=1:Nm
    for j=1:Nm
        if i==j
            Y(i,j)=sum(y(i,:));
        else Y(i,j)=-y(i,j);
        end
    end
end
Y_bus=[Y];
Yabs=abs([Y]);
Yang=angle([Y]);
Vabs=B(:,2);
Vang=B(:,3);
Pg=B(:,4);
Qg=B(:,5);
Pl=B(:,6);
Ql=B(:,7);
Pt=B(:,4)-B(:,6);
Qt=B(:,5)-B(:,7);
Vc=B(:,2).*exp(1j*B(:,3));
itr=0;
for k=1:2
NPV=0;
NPQ=0;
for i=2:Nm
SPV=0;
SPQ=0;
 if Pt(i)>0
     NPV=NPV+1;
     Psch(i)=Pt(i);
     for j=1:Nm
         SPV=SPV+Vc(j)*Y(i,j);
         I(i)=SPV;
     end
     S(i)=Vc(i)*conj(I(i));
     Pn(i)=real(S(i));
     Qnv(i)=imag(S(i));
 else
     NPQ=NPQ+1;
     Psch(i)=Pt(i);
     Qsch(i)=Qt(i);
     for j=1:Nm
         SPQ=SPQ+Vc(j)*Y(i,j);
         I(i)=SPQ;
     end
     S(i)=Vc(i)*conj(I(i));
     Pn(i)=real(S(i));
     Qn(i)=imag(S(i));
 end
end
 Pschn=nonzeros(Psch);
 Pschm=reshape(Pschn,1,NPV+NPQ)';
 Qschn=nonzeros(Qsch);
 Qschm=reshape(Qschn,1,NPQ)';
 Schedule=[Pschm;Qschm];
 Pnn=nonzeros(Pn);
 Pnm=reshape(Pnn,1,NPV+NPQ);
 Qnn=nonzeros(Qn);
 Qnm=reshape(Qnn,1,NPQ);
 NewPQ=[Pnn;Qnn];
 MisM=Schedule-NewPQ;
 for i=2:Nm
     if Pt(i)>0
         for j=2:Nm
             if i==j
             H(i,j)=-Qnv(i)-((Vabs(i)^2)*Yabs(i,j)*sin(Yang(i,j)));
             if Pt(j)<0
             L(i,j)=(Pn(i)/Vabs(i))+(Vabs(i)*Yabs(i,j)*cos(Yang(i,j)));
             end
             else
                 H(i,j)=-Vabs(i)*Vabs(j)*Yabs(i,j)*sin(Yang(i,j)+Vang(j)-Vang(i));
                 if Pt(j)<0
                 L(i,j)=Vabs(i)*Yabs(i,j)*cos(Yang(i,j)+Vang(j)-Vang(i));
                 end
             end
         end
     else
         for j=2:Nm
             if i==j
             H(i,j)=-Qn(i)-((Vabs(i)^2)*Yabs(i,j)*sin(Yang(i,j)));
             M(i,j)=Pn(i)-((Vabs(i)^2)*Yabs(i,j)*cos(Yang(i,j)));
             if Pt(j)<0
             L(i,j)=(Pn(i)/Vabs(i))+(Vabs(i)*Yabs(i,j)*cos(Yang(i,j)));
             N(i,j)=(Qn(i)/Vabs(i))-(Vabs(i)*Yabs(i,j)*sin(Yang(i,j)));
             end
             else
                 H(i,j)=-Vabs(i)*Vabs(j)*Yabs(i,j)*sin(Yang(i,j)+Vang(j)-Vang(i));
                 M(i,j)=-Vabs(i)*Vabs(j)*Yabs(i,j)*cos(Yang(i,j)+Vang(j)-Vang(i));
                 if Pt(j)<0
                     L(i,j)=Vabs(i)*Yabs(i,j)*cos(Yang(i,j)+Vang(j)-Vang(i));
                     N(i,j)=-Vabs(i)*Yabs(i,j)*sin(Yang(i,j)+Vang(j)-Vang(i));
                 end
             end
         end
     end
 end
%  Hmatn=H(2:Nm,:);
%  Hmat=Hmatn(:,2:Nm);
%  Lmatn=L(2:Nm,:);
%  Lmat=Lmatn(:,NPV+2:Nm);
%  Mmatn=M(NPV+2:Nm,:);
%  Mmat=Mmatn(:,2:Nm);
%  Nmatn=N(NPV+2:Nm,:);
%  Nmat=Nmatn(:,NPV+2:Nm);
%   ShHmm=[L]
%  ShH=[Lmatn]
 Hmatn=nonzeros(H);
 Hmat=reshape(Hmatn,NPV+NPQ,NPV+NPQ);
 Lmatn=nonzeros(L);
 Lmat=reshape(Lmatn,NPQ,NPV+NPQ);
 Mmatn=nonzeros(M);
 Mmat=reshape(Mmatn,NPV+NPQ,NPQ);
 Nmatn=nonzeros(N);
 Nmat=reshape(Nmatn,NPQ,NPQ);
 Jac=[Hmat Lmat;Mmat Nmat]
 Dev=inv(Jac)*MisM;
 Devang=Dev(1:(NPV+NPQ),:);
 Devmag=Dev((NPV+NPQ+1):(NPV+2*NPQ),:);
 for i=2:Nm
     Vang(i)=Vang(i)+Devang(i-1);
 end
 Injmv=1;
 for i=2:Nm
     if Pt(i)<0
         Vabs(i)=Vabs(i)+Devmag(Injmv);
         Injmv=Injmv+1;
     end
 end
 for i=1:Nm
     Vc(i)=Vabs(i).*exp(1j*Vang(i));
     Vabs(i)=abs(Vc(i));
     Vang(i)=angle(Vc(i));
     Vangindg(i)=rad2deg(Vang(i));
     Vreal(i)=real(Vc(i));
     Vimag(i)=imag(Vc(i));
 end
 term=1;
 for i=1:NPV+2*NPQ
     if MisM(i)<tol
         term=1*term;
     else
         term=0;
     end
 end
 itr=itr+1;
 if term==1
     break;
 end
end
fprintf('Required iterations= %d\n',itr);
for k=1:Nm
fprintf('Bus %i Voltage in complex form: %4f+j%4f\n',k,Vreal(k),Vimag(k));
end
for k=1:Nm
fprintf('Bus %i Voltage (Angle in Radian): %4f<%4f\n',k,Vabs(k),Vang(k));
end
for k=1:Nm
fprintf('Bus %i Voltage (Angle in Degree): %4f<%4f\n',k,Vabs(k),Vangindg(k));
end
