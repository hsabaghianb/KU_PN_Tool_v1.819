function PN_model=Weighted_Arc1()

%Make null PN model
[PN_model] = Init_PN('Weighted_Arc1');

%Define Places
%---------------------------------------------------------------
% [PN_model,Pl_num]=New_Place(PN_model,Name,Cap,Type,Marking)
%---------------------------------------------------------------
[PN_model,p1]=New_Place(PN_model,'P1',0,1,{[0,0,0,0],[0,0,0,0],[0,0,0,0]});
[PN_model,p2]=New_Place(PN_model,'P2',0,1,{[0,0,0,0],[0,0,0,0]});
[PN_model,p3]=New_Place(PN_model,'P3',0,0,{});
[PN_model,p4]=New_Place(PN_model,'P4',0,1,{});


%Define Transitions
%---------------------------------------------------------------
%[PN_model,Tr_num]=New_Transition(PN_model, Name, Firing_func_name, Type=0/1/2, TrValue=0/TrDly/Rate, TknDly, Priority, Probability)
%Type=0:Immediate 1:Timed 2:Stochastic 
%---------------------------------------------------------------
[PN_model,t1]=New_Transition(PN_model,'T1', 'General_func',0,0,0,1,1);


%Add Communication Arcs
PN_model=Weighted_Arc_P2T(PN_model,p1,t1,3);
PN_model=Weighted_Arc_P2T(PN_model,p2,t1,1);

PN_model=Weighted_Arc_T2P(PN_model,t1,p3,1);
PN_model=Weighted_Arc_T2P(PN_model,t1,p4,2);
