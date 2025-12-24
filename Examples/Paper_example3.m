function PN_model=Paper_example3()

%Make null PN model
[PN_model] = null_model_PN('Paper_example3');

%Define Places
%---------------------------------------------------------------
% [PN_model,Pl_num]=New_Place(PN_model,Name,Cap,Type,Marking)
%---------------------------------------------------------------
[PN_model,p0]=New_Place(PN_model,'P0', 0,1,{[1,1,0,0,0]});
[PN_model,p1]=New_Place(PN_model,'P1', 0,1,[]);
[PN_model,p2]=New_Place(PN_model,'P2', 0,1,[]);
[PN_model,p3]=New_Place(PN_model,'P3', 0,1,[]);
[PN_model,p4]=New_Place(PN_model,'P4', 0,1,[]);
[PN_model,p5]=New_Place(PN_model,'P5', 0,1,{[1,1,0,0,0]});
[PN_model,p6]=New_Place(PN_model,'P6', 0,1,[]);



%Define Transitions
%---------------------------------------------------------------
%[PN_model,Tr_num]=New_Transition(PN_model, Name, Firing_func_name,
%   Type=0/1/2, TrValue=0/TrDly/Rate, TknDly, Priority, Probability)
%Type=0:Immediate 1:Timed 2:Stochastic
%---------------------------------------------------------------
[PN_model,t0]=New_Transition(PN_model,'t0', 'General_func',1,10,0,1,1);
[PN_model,t1]=New_Transition(PN_model,'t1', 'General_func',0,0,0,1,0.8);
[PN_model,t2]=New_Transition(PN_model,'t2', 'General_func',0,0,0,1,0.2);
[PN_model,t3]=New_Transition(PN_model,'t3', 'General_func',1,2,0,1,1);
[PN_model,t4]=New_Transition(PN_model,'t4', 'General_func',1,2,0,1,1);
[PN_model,t5]=New_Transition(PN_model,'t5', 'General_func',1,20,0,1,1);
[PN_model,t6]=New_Transition(PN_model,'t6', 'General_func',1,64,0,1,1);
[PN_model,t7]=New_Transition(PN_model,'t7', 'General_func',0,0,0,1,1);


%Add Communication Arcs
PN_model=Arc_P2T(PN_model,p0,t0);
PN_model=Weighted_Arc_T2P(PN_model,t0,p1,1);

PN_model=Arc_P2T(PN_model,p1,t1);
PN_model=Arc_P2T(PN_model,p1,t2);

PN_model=Arc_T2P(PN_model,t1,p2);
PN_model=Arc_T2P(PN_model,t2,p3);

PN_model=Arc_P2T(PN_model,p2,t3);
PN_model=Arc_P2T(PN_model,p3,t4);

PN_model=Arc_T2P(PN_model,t3,p4);
PN_model=Arc_T2P(PN_model,t4,p4);

PN_model=Weighted_Arc_P2T(PN_model,p4,t5,1);
PN_model=Arc_T2P(PN_model,t5,p0);

PN_model=Arc_P2T(PN_model,p5,t6);
PN_model=Arc_T2P(PN_model,t6,p6);
PN_model=Arc_P2T(PN_model,p6,t7);
PN_model=Arc_T2P(PN_model,t7,p5);

