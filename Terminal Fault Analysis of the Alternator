clc;
close all
clear all
f=input('Enter the value of frequency=');
R=input('Enter the value of Resistance=');
L=input('Enter the Value of Inductance=');
Vm=input('Enter the value of the magnitude of voltage=');
alpha=input('Enter the value of phase=');
Alpha=deg2rad(alpha);
Z=abs(R+j*2*pi*f*L);
Az=angle(R+j*2*pi*f*L);
t=0:0.0001:1;
i=(Vm/Z)*sin(2*pi*f.*t+Alpha-Az)-sin(Alpha-Az)*exp(-(R.*t)./L);
plot(t,i)
xlabel('Time (t)','Fontsize',20);
ylabel('Fault Current, i','Fontsize',20);
title('Response of Short Circuit Current of an Alternator','Fontsize',20);
grid on
