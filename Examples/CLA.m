function PN_model=CLA()

%Make null PN model
[PN_model] = Init_PN('CLA');

%Define Places
%---------------------------------------------------------------
% [PN_model,Pl_num]=New_Place(PN_model,Name,Cap,Type,Marking)
%---------------------------------------------------------------
[PN_model,p1]=New_Place(PN_model,'P1',0,1,{[0,0,0,0]});
[PN_model,p2]=New_Place(PN_model,'P2',0,1,{});
[PN_model,p3]=New_Place(PN_model,'P3',0,1,{});


%Define Transitions
%---------------------------------------------------------------
%[PN_model,Tr_num]=New_Transition(PN_model, Name, Firing_func_name, Type=0/1/2, TrValue=0/TrDly/Rate, TknDly, Priority, Probability)
%Type=0:Immediate 1:Timed 2:Stochastic 
%---------------------------------------------------------------
[PN_model,t1]=New_Transition(PN_model,'T1', 'General_func',0,0,0,1,0.2);
[PN_model,t2]=New_Transition(PN_model,'T2', 'General_func',0,0,0,1,0.8);
[PN_model,t3]=New_Transition(PN_model,'T3', 'CLA_T3_func',0,0,0,1,1);
[PN_model,t4]=New_Transition(PN_model,'T4', 'CLA_T4_func',0,0,0,1,1);


%Add Communication Arcs
PN_model=Weighted_Arc_P2T(PN_model,p1,t1,1);
PN_model=Weighted_Arc_P2T(PN_model,p1,t2,1);
PN_model=Weighted_Arc_T2P(PN_model,t1,p2,1);
PN_model=Weighted_Arc_T2P(PN_model,t2,p3,1);
PN_model=Weighted_Arc_P2T(PN_model,p3,t3,1);
PN_model=Weighted_Arc_P2T(PN_model,p2,t4,1);
PN_model=Weighted_Arc_T2P(PN_model,t3,p1,1);
PN_model=Weighted_Arc_T2P(PN_model,t4,p1,1);

% [mat,shape,label]=make_biograph_matrix_from_PN_model(PN_model);
% Draw_PN_Model(PN_model);

