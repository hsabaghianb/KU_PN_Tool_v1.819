function PN_model=ReducedInitTarg()
%This model is a reduced version of Petr-Net model which is related to Mode_001_InitA_TargA communication 
%It is simulated and the results are compared with steady state analysis which is
%done by means of the function Steady_State_Mode_001_InitA_TargA()


%Make null PN model
[PN_model] = Init_PN('ReducedInitTarg');

%Define Places
%---------------------------------------------------------------
% [PN_model,Pl_num]=New_Place(PN_model,Name,Cap,Type,Marking)
%---------------------------------------------------------------
[PN_model,p0]=New_Place(PN_model,'P0',0,1,{[1,1,0,0],[1,2,0,0]});
% [PN_model,p0]=New_Place(PN_model,'P0',0,1,{[1,1,0,0],[1,2,0,0],[1,3,0,0],[1,4,0,0],[1,5,0,0],[1,6,0,0],[1,7,0,0],[1,8,0,0],[1,9,0,0],[1,10,0,0],[1,11,0,0]});
[PN_model,p1]=New_Place(PN_model,'P1',0,1,{});
[PN_model,p2]=New_Place(PN_model,'P2',0,0,{[0,0,0,0]});
[PN_model,p3]=New_Place(PN_model,'P3',0,1,{});
[PN_model,p4]=New_Place(PN_model,'P4',0,1,{});
[PN_model,p5]=New_Place(PN_model,'P5',0,0,{[0,0,0,0]});
[PN_model,p6]=New_Place(PN_model,'P6',0,1,{});
[PN_model,p7]=New_Place(PN_model,'P7',0,0,{[0,0,0,0]});


%Define Transitions
%---------------------------------------------------------------
%[PN_model,Tr_num]=New_Transition(PN_model, Name, Firing_func_name, Type=0/1/2, TrValue=0/TrDly/Rate, TknDly, Priority, Probability)
%Type=0:Immediate 1:Timed 2:Stochastic 
%---------------------------------------------------------------
[PN_model,t1]=New_Transition(PN_model,'T1', 'General_func',1,20,0,1,1);
[PN_model,t2]=New_Transition(PN_model,'T2', 'General_func',0,0,0,1,1);
[PN_model,t3]=New_Transition(PN_model,'T3', 'General_func',1,8,0,1,1);
[PN_model,t4]=New_Transition(PN_model,'T4', 'General_func',1,7,0,1,1);
[PN_model,t5]=New_Transition(PN_model,'T5', 'General_func',1,30,0,1,1);


%Add Communication Arcs
PN_model=Arc_P2T(PN_model,p0,t1);

PN_model=Arc_T2P(PN_model,t1,p1);
PN_model=Arc_P2T(PN_model,p1,t2);
PN_model=Arc_T2P(PN_model,t2,p2);
PN_model=Arc_P2T(PN_model,p2,t1);
PN_model=Arc_T2P(PN_model,t2,p3);
PN_model=Arc_P2T(PN_model,p3,t3);
PN_model=Arc_T2P(PN_model,t3,p4);
PN_model=Arc_P2T(PN_model,p4,t4);
PN_model=Arc_T2P(PN_model,t4,p5);
PN_model=Arc_P2T(PN_model,p5,t2);
PN_model=Arc_T2P(PN_model,t4,p6);
PN_model=Arc_P2T(PN_model,p6,t5);
PN_model=Arc_T2P(PN_model,t5,p7);
PN_model=Arc_P2T(PN_model,p7,t3);

% [mat,shape,label]=make_biograph_matrix_from_PN_model(PN_model);
% Draw_PN_Model(PN_model,mat,shape,label);

