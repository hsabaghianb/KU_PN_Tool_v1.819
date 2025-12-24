function PN_model=MECS_Lec20_Example_3()
[PN_model] = Init_PN('MECS_Lec20_Example_3');
%Define Places
[PN_model,p1]=New_Place(PN_model,'P1',0,1,{[1,1,0,0]}); %,[1,2,0,0],[1,3,0,0],[1,4,0,0],[1,5,0,0]});
[PN_model,p2]=New_Place(PN_model,'P2',0,1,{});
[PN_model,p4]=New_Place(PN_model,'P4',0,1,{});
[PN_model,p5]=New_Place(PN_model,'P5',0,1,{});

%Define Transitions
[PN_model,t1]=New_Transition(PN_model,'T1', 'General_func',1,1,0,0,1);
[PN_model,t2]=New_Transition(PN_model,'T2', 'General_func',1,4,0,0,1);
[PN_model,t3]=New_Transition(PN_model,'T3', 'General_func',1,3,0,0,1);
[PN_model,t4]=New_Transition(PN_model,'T4', 'General_func',1,2,0,0,1);
%Add Communication Arcs
PN_model=Weighted_Arc_P2T(PN_model,p1,t1,1);
PN_model=Weighted_Arc_T2P(PN_model,t1,p2,1);
PN_model=Weighted_Arc_P2T(PN_model,p2,t2,1);
PN_model=Weighted_Arc_P2T(PN_model,p2,t3,1);
PN_model=Weighted_Arc_T2P(PN_model,t2,p4,1);
PN_model=Weighted_Arc_T2P(PN_model,t3,p4,1);
PN_model=Weighted_Arc_P2T(PN_model,p4,t4,1);
PN_model=Weighted_Arc_T2P(PN_model,t4,p5,1);


