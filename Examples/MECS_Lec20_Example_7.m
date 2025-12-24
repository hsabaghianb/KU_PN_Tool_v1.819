function PN_model=MECS_Lec20_Example_7()
[PN_model] = Init_PN('MECS_Lec20_Example_7');
%Define Places
[PN_model,p1]=New_Place(PN_model,'P1',0,1,{[1,1,0,0]});%,[1,2,0,0],[1,3,0,0],[1,4,0,0],[1,5,0,0]});
[PN_model,p2]=New_Place(PN_model,'P2',0,1,{});
[PN_model,p3]=New_Place(PN_model,'P3',0,1,{});
[PN_model,p4]=New_Place(PN_model,'P4',0,1,{});
[PN_model,p5]=New_Place(PN_model,'P5',0,1,{});
[PN_model,p6]=New_Place(PN_model,'P6',0,1,{});
[PN_model,p7]=New_Place(PN_model,'P7',0,1,{});
[PN_model,p8]=New_Place(PN_model,'P8',0,1,{});
[PN_model,p9]=New_Place(PN_model,'P9',0,1,{});


%Define Transitions
[PN_model,t1]=New_Transition(PN_model,'T1', 'General_func',2,2,0,0,1);
[PN_model,t2]=New_Transition(PN_model,'T2', 'General_func',2,3,0,0,1);
[PN_model,t3]=New_Transition(PN_model,'T3', 'General_func',2,4,0,0,1);
[PN_model,t4]=New_Transition(PN_model,'T4', 'General_func',2,4,0,0,1);

[PN_model,t5]=New_Transition(PN_model,'t5', 'General_func',0,0,0,0,1);
[PN_model,t6]=New_Transition(PN_model,'t6', 'General_func',0,0,0,0,1);
[PN_model,t7]=New_Transition(PN_model,'t7', 'General_func',0,0,0,0,1);
[PN_model,t8]=New_Transition(PN_model,'t8', 'General_func',0,0,0,0,1);

[PN_model,t9]=New_Transition(PN_model,'T9', 'General_func',2,4,0,0,1);


%Add Communication Arcs
PN_model=Weighted_Arc_P2T(PN_model,p1,t1,1);
PN_model=Weighted_Arc_T2P(PN_model,t1,p2,1);

PN_model=Weighted_Arc_P2T(PN_model,p2,t5,1);
PN_model=Weighted_Arc_T2P(PN_model,t5,p3,1);
PN_model=Weighted_Arc_T2P(PN_model,t5,p4,1);

PN_model=Weighted_Arc_P2T(PN_model,p3,t2,1);
PN_model=Weighted_Arc_P2T(PN_model,p4,t3,1);

PN_model=Weighted_Arc_T2P(PN_model,t2,p5,1);
PN_model=Weighted_Arc_T2P(PN_model,t3,p6,1);

PN_model=Weighted_Arc_P2T(PN_model,p5,t6,1);
PN_model=Weighted_Arc_P2T(PN_model,p6,t6,1);

PN_model=Weighted_Arc_T2P(PN_model,t6,p7,1);
PN_model=Weighted_Arc_P2T(PN_model,p7,t7,1);
PN_model=Weighted_Arc_P2T(PN_model,p7,t8,1);
PN_model=Weighted_Arc_T2P(PN_model,t7,p8,1);
PN_model=Weighted_Arc_P2T(PN_model,p8,t9,1);
PN_model=Weighted_Arc_T2P(PN_model,t9,p2,1);
PN_model=Weighted_Arc_T2P(PN_model,t8,p9,1);
PN_model=Weighted_Arc_P2T(PN_model,p9,t4,1);
PN_model=Weighted_Arc_T2P(PN_model,t4,p1,1);

