function PN_model=Football_Play_2team()


%Make null PN model
[PN_model] = Init_PN('Football_Play_2team');

%Define Places
%---------------------------------------------------------------
% [PN_model,Pl_num]=New_Place(PN_model,Name,Cap,Type,Marking)
%---------------------------------------------------------------
[PN_model,Team1]=New_Place(PN_model,'Team1',0,1,{[1,1,0,0],[1,1,0,0],[1,1,0,0]});
[PN_model,Team2]=New_Place(PN_model,'Team2',0,1,{[1,1,0,0],[1,1,0,0],[1,1,0,0]});
[PN_model,Score1]=New_Place(PN_model,'Score1',0,1,{});
[PN_model,Score2]=New_Place(PN_model,'Score2',0,1,{});
[PN_model,Playing]=New_Place(PN_model,'Playing',1,1,{});

%Define Transitions
%---------------------------------------------------------------
%[PN_model,Tr_num]=New_Transition(PN_model, Name, Firing_func_name, Type=0/1/2, TrValue=0/TrDly/Rate, TknDly, Priority, Probability)
%Type=0:Immediate 1:Timed 2:Stochastic 
%---------------------------------------------------------------
[PN_model,Do_Play]=New_Transition(PN_model,'Do_Play', 'General_func',0,0,0,1,1);
[PN_model,Win]=New_Transition(PN_model,'Win', 'General_func',0,0,0,1,1);
[PN_model,Lose]=New_Transition(PN_model,'Lose', 'General_func',0,0,0,1,1);
[PN_model,Equal]=New_Transition(PN_model,'Equal', 'General_func',0,0,0,1,1);

%Add Communication Arcs
PN_model=Weighted_Arc_P2T(PN_model,Team1,Do_Play,1);
PN_model=Weighted_Arc_P2T(PN_model,Team2,Do_Play,1);
PN_model=Weighted_Arc_P2T(PN_model,Playing,Win,1);
PN_model=Weighted_Arc_P2T(PN_model,Playing,Lose,1);
PN_model=Weighted_Arc_P2T(PN_model,Playing,Equal,1);

PN_model=Weighted_Arc_T2P(PN_model,Do_Play,Playing,1);
PN_model=Weighted_Arc_T2P(PN_model,Win,Score1,3);
PN_model=Weighted_Arc_T2P(PN_model,Lose,Score2,3);
PN_model=Weighted_Arc_T2P(PN_model,Equal,Score1,1);
PN_model=Weighted_Arc_T2P(PN_model,Equal,Score2,1);


