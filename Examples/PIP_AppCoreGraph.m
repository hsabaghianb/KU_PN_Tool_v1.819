function PN_model=PIP_AppCoreGraph()
OneSec=1024;
[PN_model] = Init_PN('PIP_AppCoreGraph');
%Define Places
%---------------------------------------------------------------
% [PN_model,Pl_num]=New_Place(PN_model,Name,Cap,Type,Marking)
%---------------------------------------------------------------
[PN_model,p1]=New_Place(PN_model,'P1',0,1,{});
[PN_model,p2]=New_Place(PN_model,'P2',0,1,{});
[PN_model,p3]=New_Place(PN_model,'P3',0,1,{});
[PN_model,p4]=New_Place(PN_model,'P4',0,1,{});
[PN_model,p5]=New_Place(PN_model,'P5',0,1,{});
[PN_model,p6]=New_Place(PN_model,'P6',0,1,{});
[PN_model,p7]=New_Place(PN_model,'P7',0,1,{});
[PN_model,p8]=New_Place(PN_model,'P8',0,1,{});
[PN_model,p9]=New_Place(PN_model,'P9',0,1,{});
[PN_model,p10]=New_Place(PN_model,'P10',0,1,{});
[PN_model,p11]=New_Place(PN_model,'P11',0,1,{});
[PN_model,p12]=New_Place(PN_model,'P12',0,1,{});
[PN_model,p13]=New_Place(PN_model,'P13',0,1,{});
[PN_model,p14]=New_Place(PN_model,'P14',0,1,{});
[PN_model,p15]=New_Place(PN_model,'P15',0,1,{});

%Define Transitions
%-------------------------------------------------------------------------------------------
%[PN_model,Tr_num]=New_Transition(PN_model, Name, Firing_func_name, Type=0/1/2, TrValue=0/TrDly/Rate, TknDly, Priority, Probability)
%Type=0:Immediate 1:Timed 2:Stochastic 
%-------------------------------------------------------------------------------------------
[PN_model,it1]=New_Transition(PN_model,'IT1', 'General_func',0,0,0,15,1);
[PN_model,it2]=New_Transition(PN_model,'IT2', 'General_func',0,0,0,14,1);
[PN_model,it3]=New_Transition(PN_model,'IT3', 'General_func',0,0,0,14,1);
[PN_model,it4]=New_Transition(PN_model,'IT4', 'General_func',0,0,0,13,1);
[PN_model,it5]=New_Transition(PN_model,'IT5', 'General_func',0,0,0,13,1);
[PN_model,it6]=New_Transition(PN_model,'IT6', 'General_func',0,0,0,12,1);
[PN_model,it7]=New_Transition(PN_model,'IT7', 'General_func',0,0,0,11,1);
[PN_model,it8]=New_Transition(PN_model,'IT8', 'General_func',0,0,0,10,1);


[PN_model,tt1]=New_Transition(PN_model,'TT1', 'General_func',1, OneSec/64, 0,25,1);
[PN_model,tt2]=New_Transition(PN_model,'TT2', 'General_func',1, OneSec/128,0,24,1);
[PN_model,tt3]=New_Transition(PN_model,'TT3', 'General_func',1, OneSec/64, 0,24,1);
[PN_model,tt4]=New_Transition(PN_model,'TT4', 'General_func',1, OneSec/64, 0,23,1);
[PN_model,tt5]=New_Transition(PN_model,'TT5', 'General_func',1, OneSec/64, 0,23,1);
[PN_model,tt6]=New_Transition(PN_model,'TT6', 'General_func',1, OneSec/64, 0,21,1);
[PN_model,tt7]=New_Transition(PN_model,'TT7', 'General_func',1, OneSec/64, 0,22,1);
[PN_model,tt8]=New_Transition(PN_model,'TT8', 'General_func',1, OneSec/64, 0,21,1);
[PN_model,tt9]=New_Transition(PN_model,'TT9', 'General_func',1, OneSec/64, 0,20,1);

%Add Communication Arcs
PN_model=Weighted_Arc_T2P(PN_model,tt1,p1,1);
PN_model=Weighted_Arc_P2T(PN_model,p1,it1,1);
PN_model=Weighted_Arc_T2P(PN_model,it1,p2,3);
PN_model=Weighted_Arc_P2T(PN_model,p2,tt2,1);
PN_model=Weighted_Arc_P2T(PN_model,p2,tt3,1);
PN_model=Weighted_Arc_T2P(PN_model,tt2,p3,1);
PN_model=Weighted_Arc_T2P(PN_model,tt3,p5,1);
PN_model=Weighted_Arc_P2T(PN_model,p3,it2,2);
PN_model=Weighted_Arc_P2T(PN_model,p5,it3,1);
PN_model=Weighted_Arc_T2P(PN_model,it2,p4,1);
PN_model=Weighted_Arc_T2P(PN_model,it3,p6,1);
PN_model=Weighted_Arc_P2T(PN_model,p4,tt5,1);
PN_model=Weighted_Arc_P2T(PN_model,p6,tt4,1);
PN_model=Weighted_Arc_T2P(PN_model,tt5,p7,1);
PN_model=Weighted_Arc_T2P(PN_model,tt4,p9,1);
PN_model=Weighted_Arc_P2T(PN_model,p7,it5,1);
PN_model=Weighted_Arc_P2T(PN_model,p9,it4,1);
PN_model=Weighted_Arc_T2P(PN_model,it5,p8,1);
PN_model=Weighted_Arc_T2P(PN_model,it4,p10,1);
PN_model=Weighted_Arc_P2T(PN_model,p8,tt6,1);
PN_model=Weighted_Arc_P2T(PN_model,p10,tt8,1);
PN_model=Weighted_Arc_T2P(PN_model,tt6,p11,1);
PN_model=Weighted_Arc_T2P(PN_model,tt8,p13,1);
PN_model=Weighted_Arc_P2T(PN_model,p11,it6,1);
PN_model=Weighted_Arc_T2P(PN_model,it6,p12,1);
PN_model=Weighted_Arc_P2T(PN_model,p12,tt7,1);
PN_model=Weighted_Arc_T2P(PN_model,tt7,p13,1);
PN_model=Weighted_Arc_P2T(PN_model,p13,it7,2);
PN_model=Weighted_Arc_T2P(PN_model,it7,p14,1);
PN_model=Weighted_Arc_P2T(PN_model,p14,tt9,1);
PN_model=Weighted_Arc_T2P(PN_model,tt9,p15,1);
PN_model=Weighted_Arc_P2T(PN_model,p15,it8,1);

PN_model.Transition_Report_List=[it8];


