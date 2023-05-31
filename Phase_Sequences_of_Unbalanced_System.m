clc;
close all
clear all
Va=input('Enter the value of Va=');
Vb=input('Enter the value of Vb=');
Vc=input('Enter the value of Vc=');
a=exp(1j*(2*pi/3));
asq=a.*a;
Va0=(1/3)*(Va+Vb+Vc);
Va1=(1/3)*(Va+a*Vb+asq*Vc);
Va2=(1/3)*(Va+asq*Vb+a*Vc);
%Positive sequence
Vb1=asq*Va1;
Vc1=a*Va1;
%Negative sequence
Vb2=a*Va2;
Vc2=asq*Va2;
%Zero sequence
Vb0=Va0;
Vc0=Va0;
subplot(2,2,1)
compass([Va,Vb,Vc])
title('Unbalanced System','Fontsize',16);
grid on
subplot(2,2,2)
compass([Va1,Vb1,Vc1])
title('Positive Sequence','Fontsize',16);
subplot(2,2,3)
compass([Va2,Vb2,Vc2])
title('Negative Sequence','Fontsize',16);
subplot(2,2,4)
compass([Va0,Vb0,Vc0])
title('Zero Sequence','Fontsize',16);
