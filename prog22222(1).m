clc;
clear all;
close all;
A=0.90;
D=0.30;
alphaFalse=2.3;
alphaMonitor = 2.4;
alphaAttack=2;
Rm=200;
r=0.15;
t=[0,1];
x(t)=1;
T=1;
Rj=1;
SDi=2;
SAj=2;
PhiDi(t)=SDi;
Vx=0;
% resource consumption of attacker at time t
% resource consumption of defender at time t
U*Di(t); 
Vx = PhiDi*exp^-r; %% as per equation 17 %%
%%calculating the nash equilibrium
%%U*Di is the partial derivative of UDi %%
U*Di(t)=-[(1-x)^1/2 Vx^Di(t,x)exp^r(t-t0)] 2.zita; %%% as per equation-11%%
U*Aj(t)=-[(x^1/2 .Vx^Aj(t,x) exp ^r(t-t0)/(2 rhoA.alphaAttack)];%% as per equation-13%%

zita=rhoaA.rhoaD.alphaFalse-rhoaD.alphaMonitor-rhoaD.alphaFalse;
A= rhoA.rhoD.Rm+2.rhoA.rhoD.Rm.x(t)+zita.UDi(t)^2;
B= rhoA ;Rj -2.rhoA .rhoD.Rmx(t)-rhoA.alphaAttack.UAj(t)^2;
%%calculatiing optimization overall payoff of PD
%%calculatiing optimization overall payoff of PA
UD= int(Aexp^-r(t-t0)'s',0;1)+SDi(x(T))exp^-r(t-t0);
UA= int (Bexp^-r(t-t0)'s',0;1 )+SAj(1-x(T)) exp^-r(t-t0);
