
function PN_model=InhArcExample()

%Make null PN model
[PN_model] = Init_PN('InhArcExample');

%Define Places
%---------------------------------------------------------------
% [PN_model,Pl_num]=New_Place(PN_model,Name,Cap,Type,Marking)
%---------------------------------------------------------------
[PN_model,p1]=New_Place(PN_model,'P1',0,1,{});
[PN_model,p2]=New_Place(PN_model,'P2',0,1,{});

%Define Transitions
%---------------------------------------------------------------
%[PN_model,Tr_num]=New_Transition(PN_model, Name, Firing_func_name, 
%   Type=0/1/2, TrValue=0/TrDly/Rate, TknDly, Priority, Probability)
%Type=0:Immediate 1:Timed 2:Stochastic 
%---------------------------------------------------------------
[PN_model,t1]=New_Transition(PN_model,'T1', 'General_func',0,0,0,1,1);
[PN_model,t2]=New_Transition(PN_model,'T2', 'General_func',0,0,0,1,1);

%Add Communication Arcs
% PN_model=Weighted_Arc_T2P(PN_model,t1,p1,1);
PN_model=Weight_InhArc_P2T(PN_model,p1,t1,1);
PN_model=Weight_InhArc_P2T(PN_model,p2,t1,1);
% PN_model=Weighted_Arc_T2P(PN_model,t2,t1,5);




