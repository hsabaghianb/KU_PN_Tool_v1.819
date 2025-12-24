
function PN_model=example1()

%Make null PN model
[PN_model] = Init_PN('example1');

%Define Places
%---------------------------------------------------------------
% [PN_model,Pl_num]=New_Place(PN_model,Name,Cap,Type,Marking)
%---------------------------------------------------------------
[PN_model,p1]=New_Place(PN_model,'P1',0,1,{[1,1,0,0,0]});
[PN_model,p2]=New_Place(PN_model,'P2',0,1,{});
[PN_model,p3]=New_Place(PN_model,'P3',0,1,{});

%Define Transitions
%---------------------------------------------------------------
%[PN_model,Tr_num]=New_Transition(PN_model, Name, Firing_func_name, 
%   Type=0/1/2, TrValue=0/TrDly/Rate, TknDly, Priority, Probability)
%Type=0:Immediate 1:Timed 2:Stochastic 
%---------------------------------------------------------------
[PN_model,t1]=New_Transition(PN_model,'T1', 'General_func',1,11,0,1,1);
[PN_model,t2]=New_Transition(PN_model,'T2', 'General_func',1,5,0,1,1);
[PN_model,t3]=New_Transition(PN_model,'T3', 'General_func',1,3,0,1,1);

%Add Communication Arcs
PN_model=Weighted_Arc_P2T(PN_model,p1,t1,1);
PN_model=Weighted_Arc_T2P(PN_model,t1,p2,1);
PN_model=Weighted_Arc_P2T(PN_model,p2,t2,1);
PN_model=Weighted_Arc_T2P(PN_model,t2,p1,2);
% PN_model=Weighted_Arc_P2T(PN_model,p3,t2,1);

PN_model=Weighted_Arc_P2T(PN_model,p1,t3,3);
PN_model=Weighted_Arc_T2P(PN_model,t3,p3,1);

  Draw_Petri_Net(PN_model);




