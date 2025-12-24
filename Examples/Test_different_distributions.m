function PN_model=Stochastic()

%Make null PN model
[PN_model] = Init_PN('Stochastic');

%Define Places
%---------------------------------------------------------------
% [PN_model,Pl_num]=New_Place(PN_model,Name,Cap,Type,Marking)
%---------------------------------------------------------------
[PN_model,p0]=New_Place(PN_model,'P0',0,1,{[0,0,0,0]});
[PN_model,p1]=New_Place(PN_model,'P1',0,1,{});


%Define Transitions
%---------------------------------------------------------------
%[PN_model,Tr_num]=New_Transition(PN_model, Name, Firing_func_name, Type=0/1/2, TrValue=0/TrDly/Rate, TknDly, Priority, Probability)
%Type=0:Immediate 1:Timed 2:Stochastic 
%---------------------------------------------------------------

% [PN_model,t1]=New_Transition(PN_model,'T1', 'General_func',4,[10,20],0,1,1);   %Uniform(1,20)
[PN_model,t1]=New_Transition(PN_model,'T1', 'General_func',3,[10,0.5],0,1,1);  %Normal(10,0.5)
% [PN_model,t1]=New_Transition(PN_model,'T1', 'General_func',2,0.1,0,1,1);       %Exponential(0.1) 

[PN_model,t2]=New_Transition(PN_model,'T2', 'General_func',0,0,0,1,1);



%Add Communication Arcs
PN_model=Arc_P2T(PN_model,p0,t1);
PN_model=Arc_T2P(PN_model,t1,p1);
PN_model=Arc_P2T(PN_model,p1,t2);
PN_model=Arc_T2P(PN_model,t2,p0);

