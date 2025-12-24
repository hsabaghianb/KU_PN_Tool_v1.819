function PN_model=State_Machine()

%Make null PN model
[PN_model] = Init_PN('State_Machine');

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
[PN_model,t1]=New_Transition(PN_model,'T1', 'General_func',0,0,0,1,0.6);
[PN_model,t2]=New_Transition(PN_model,'T2', 'General_func',0,0,0,1,0.1);
[PN_model,t3]=New_Transition(PN_model,'T3', 'General_func',0,0,0,1,0.3);
[PN_model,t4]=New_Transition(PN_model,'T4', 'General_func',0,0,0,1,0.4);
[PN_model,t5]=New_Transition(PN_model,'T5', 'General_func',0,0,0,1,0.45);
[PN_model,t6]=New_Transition(PN_model,'T6', 'General_func',0,0,0,1,0.15);
[PN_model,t7]=New_Transition(PN_model,'T7', 'General_func',0,0,0,1,0.15);
[PN_model,t8]=New_Transition(PN_model,'T8', 'General_func',0,0,0,1,0.6);
[PN_model,t9]=New_Transition(PN_model,'T9', 'General_func',0,0,0,1,0.25);


%Add Communication Arcs
PN_model=Weighted_Arc_P2T(PN_model,p1,t1,1);
PN_model=Weighted_Arc_P2T(PN_model,p1,t2,1);
PN_model=Weighted_Arc_P2T(PN_model,p1,t3,1);
PN_model=Weighted_Arc_T2P(PN_model,t1,p1,1);
PN_model=Weighted_Arc_T2P(PN_model,t2,p2,1);
PN_model=Weighted_Arc_T2P(PN_model,t3,p3,1);

PN_model=Weighted_Arc_P2T(PN_model,p2,t4,1);
PN_model=Weighted_Arc_P2T(PN_model,p2,t5,1);
PN_model=Weighted_Arc_P2T(PN_model,p2,t6,1);
PN_model=Weighted_Arc_T2P(PN_model,t4,p1,1);
PN_model=Weighted_Arc_T2P(PN_model,t5,p2,1);
PN_model=Weighted_Arc_T2P(PN_model,t6,p3,1);

PN_model=Weighted_Arc_P2T(PN_model,p3,t7,1);
PN_model=Weighted_Arc_P2T(PN_model,p3,t8,1);
PN_model=Weighted_Arc_P2T(PN_model,p3,t9,1);
PN_model=Weighted_Arc_T2P(PN_model,t7,p1,1);
PN_model=Weighted_Arc_T2P(PN_model,t8,p2,1);
PN_model=Weighted_Arc_T2P(PN_model,t9,p3,1);

% [mat,shape,label]=make_biograph_matrix_from_PN_model(PN_model);
Draw_PN_Model(PN_model);

