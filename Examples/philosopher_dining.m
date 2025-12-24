function PN_model=philosopher_dining()


%Make null PN model
[PN_model] = Init_PN('philosopher_dining');

%Define Places
%---------------------------------------------------------------
% [PN_model,Pl_num]=New_Place(PN_model,Name,Cap,Type,Marking)
%---------------------------------------------------------------
[PN_model,Fork1]=New_Place(PN_model,'Fork1',0,1,{[1,1,0,0]});
[PN_model,Fork2]=New_Place(PN_model,'Fork2',0,1,{[1,2,0,0]});
[PN_model,Fork3]=New_Place(PN_model,'Fork3',0,1,{[1,3,0,0]});
[PN_model,Fork4]=New_Place(PN_model,'Fork4',0,1,{[1,4,0,0]});
[PN_model,Fork5]=New_Place(PN_model,'Fork5',0,1,{[1,5,0,0]});

[PN_model,Eating1]=New_Place(PN_model,'Eating1',0,1,{});
[PN_model,Eating2]=New_Place(PN_model,'Eating2',0,1,{});
[PN_model,Eating3]=New_Place(PN_model,'Eating3',0,1,{});
[PN_model,Eating4]=New_Place(PN_model,'Eating4',0,1,{});
[PN_model,Eating5]=New_Place(PN_model,'Eating5',0,1,{});

%Define Transitions
%---------------------------------------------------------------
%[PN_model,Tr_num]=New_Transition(PN_model, Name, Firing_func_name, Type=0/1/2, TrValue=0/TrDly/Rate, TknDly, Priority, Probability)
%Type=0:Immediate 1:Timed 2:Stochastic 
%---------------------------------------------------------------
[PN_model,Get1]=New_Transition(PN_model,'Get1', 'General_func',0,0,0,1,1);
[PN_model,Get2]=New_Transition(PN_model,'Get2', 'General_func',0,0,0,1,1);
[PN_model,Get3]=New_Transition(PN_model,'Get3', 'General_func',0,0,0,1,1);
[PN_model,Get4]=New_Transition(PN_model,'Get4', 'General_func',0,0,0,1,1);
[PN_model,Get5]=New_Transition(PN_model,'Get5', 'General_func',0,0,0,1,1);

[PN_model,Put1]=New_Transition(PN_model,'Put1', 'General_func',0,0,0,1,1);
[PN_model,Put2]=New_Transition(PN_model,'Put2', 'General_func',0,0,0,1,1);
[PN_model,Put3]=New_Transition(PN_model,'Put3', 'General_func',0,0,0,1,1);
[PN_model,Put4]=New_Transition(PN_model,'Put4', 'General_func',0,0,0,1,1);
[PN_model,Put5]=New_Transition(PN_model,'Put5', 'General_func',0,0,0,1,1);


%Add Communication Arcs
PN_model=Arc_P2T(PN_model,Fork1,Get1);
PN_model=Arc_P2T(PN_model,Fork2,Get2);
PN_model=Arc_P2T(PN_model,Fork3,Get3);
PN_model=Arc_P2T(PN_model,Fork4,Get4);
PN_model=Arc_P2T(PN_model,Fork5,Get5);

PN_model=Arc_P2T(PN_model,Fork2,Get1);
PN_model=Arc_P2T(PN_model,Fork3,Get2);
PN_model=Arc_P2T(PN_model,Fork4,Get3);
PN_model=Arc_P2T(PN_model,Fork5,Get4);
PN_model=Arc_P2T(PN_model,Fork1,Get5);

PN_model=Arc_P2T(PN_model,Eating1,Put1);
PN_model=Arc_P2T(PN_model,Eating2,Put2);
PN_model=Arc_P2T(PN_model,Eating3,Put3);
PN_model=Arc_P2T(PN_model,Eating4,Put4);
PN_model=Arc_P2T(PN_model,Eating5,Put5);

PN_model=Arc_T2P(PN_model,Get1,Eating1);
PN_model=Arc_T2P(PN_model,Get2,Eating2);
PN_model=Arc_T2P(PN_model,Get3,Eating3);
PN_model=Arc_T2P(PN_model,Get4,Eating4);
PN_model=Arc_T2P(PN_model,Get5,Eating5);

PN_model=Arc_T2P(PN_model,Put1,Fork1);
PN_model=Arc_T2P(PN_model,Put2,Fork2);
PN_model=Arc_T2P(PN_model,Put3,Fork3);
PN_model=Arc_T2P(PN_model,Put4,Fork4);
PN_model=Arc_T2P(PN_model,Put5,Fork5);

PN_model=Arc_T2P(PN_model,Put1,Fork2);
PN_model=Arc_T2P(PN_model,Put2,Fork3);
PN_model=Arc_T2P(PN_model,Put3,Fork4);
PN_model=Arc_T2P(PN_model,Put4,Fork5);
PN_model=Arc_T2P(PN_model,Put5,Fork1);


%  [mat,shape,label]=make_biograph_matrix_from_PN_model(PN_model);
%  Draw_PN_Model(PN_model,mat,shape,label);

