function PN_model=CloseLoop_1in1()

%Make null PN model
[PN_model] = Init_PN('CloseLoop_1in1');

%Define Places
%---------------------------------------------------------------
% [PN_model,Pl_num]=New_Place(PN_model,Name,Cap,Type,Marking)
%---------------------------------------------------------------
[PN_model,p1]=New_Place(PN_model,'P1',0,1,{[0,0,0,0]});
[PN_model,p2]=New_Place(PN_model,'P2',0,1,{});
[PN_model,p3]=New_Place(PN_model,'P3',0,1,{});
[PN_model,p4]=New_Place(PN_model,'P4',0,1,{});
[PN_model,p5]=New_Place(PN_model,'P5',0,1,{});


%Define Transitions
%---------------------------------------------------------------
%[PN_model,Tr_num]=New_Transition(PN_model, Name, Firing_func_name, Type=0/1/2, TrValue=0/TrDly/Rate, TknDly, Priority, Probability)
%Type=0:Immediate 1:Timed 2:Stochastic 
%---------------------------------------------------------------
[PN_model,t1]=New_Transition(PN_model,'T1', 'General_func',1,20,0,1,1);
[PN_model,t2]=New_Transition(PN_model,'T2', 'General_func',1,15,0,1,1);
[PN_model,t3]=New_Transition(PN_model,'T3', 'General_func',1,8,0,1,1);
[PN_model,t4]=New_Transition(PN_model,'T4', 'General_func',1,12,0,1,0.25);
[PN_model,t5]=New_Transition(PN_model,'T5', 'General_func',1,6,0,1,0.75);


%Add Communication Arcs
% PN_model=Arc_T2P(PN_model,t1,p1);
PN_model=Arc_P2T(PN_model,p1,t1);
PN_model=Arc_T2P(PN_model,t1,p2);
PN_model=Arc_T2P(PN_model,t1,p3);
PN_model=Arc_P2T(PN_model,p2,t2);
PN_model=Arc_P2T(PN_model,p3,t3);
PN_model=Arc_T2P(PN_model,t2,p4);
PN_model=Arc_T2P(PN_model,t3,p5);
PN_model=Arc_P2T(PN_model,p4,t4);
PN_model=Arc_T2P(PN_model,t4,p2);
PN_model=Arc_P2T(PN_model,p4,t5);
PN_model=Arc_P2T(PN_model,p5,t5);
PN_model=Arc_T2P(PN_model,t5,p1);

% [mat,shape,label]=make_biograph_matrix_from_PN_model(PN_model);
%  Draw_PN_Model(PN_model);

