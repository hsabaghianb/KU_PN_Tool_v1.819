function PN_model=Football_Play_4team()


%Make null PN model
[PN_model] = Init_PN('Football_Play_4team');
for i=1:4
    [PN_model,Team(i)]=New_Place(PN_model,['Team',num2str(i)],0,1,{[1,1,0,0],[1,1,0,0],[1,1,0,0]});
    [PN_model,Score(i)]=New_Place(PN_model,['Score',num2str(i)],0,1,{});
end    
t=1;
for i=1:3
for k=i+1:4
%     k=i+1;
%     if k==5 
%         k=1;
%     end

    %Define Places
    %---------------------------------------------------------------
    % [PN_model,Pl_num]=New_Place(PN_model,Name,Cap,Type,Marking)
    %---------------------------------------------------------------
    [PN_model,Playing(t)]=New_Place(PN_model,['Played',num2str(t)],0,1,{});
    [PN_model,Permission(t)]=New_Place(PN_model,['Permit',num2str(t)],0,1,{[1,1,0,0]});

    %Define Transitions
    %---------------------------------------------------------------
    %[PN_model,Tr_num]=New_Transition(PN_model, Name, Firing_func_name, Type=0/1/2, TrValue=0/TrDly/Rate, TknDly, Priority, Probability)
    %Type=0:Immediate 1:Timed 2:Stochastic 
    %---------------------------------------------------------------
    [PN_model,Do_Play(t)]=New_Transition(PN_model,['Do_Play',num2str(t)], 'General_func',0,0,0,t,1);
    [PN_model,Win(t)]=New_Transition(PN_model,['Win',num2str(t)], 'General_func',0,0,0,t,0.3);
    [PN_model,Lose(t)]=New_Transition(PN_model,['Lose',num2str(t)], 'General_func',0,0,0,t,0.3);
    [PN_model,Equal(t)]=New_Transition(PN_model,['Equal',num2str(t)], 'General_func',0,0,0,t,0.4);

    %Add Communication Arcs
    PN_model=Weighted_Arc_P2T(PN_model,Team(i),Do_Play(t),1);
    PN_model=Weighted_Arc_P2T(PN_model,Team(k),Do_Play(t),1);
    PN_model=Weighted_Arc_P2T(PN_model,Permission(t),Do_Play(t),1);
    PN_model=Weighted_Arc_P2T(PN_model,Playing(t),Win(t),1);
    PN_model=Weighted_Arc_P2T(PN_model,Playing(t),Lose(t),1);
    PN_model=Weighted_Arc_P2T(PN_model,Playing(t),Equal(t),1);

    PN_model=Weighted_Arc_T2P(PN_model,Do_Play(t),Playing(t),1);
    PN_model=Weighted_Arc_T2P(PN_model,Win(t),Score(i),3);
    PN_model=Weighted_Arc_T2P(PN_model,Lose(t),Score(k),3);
    PN_model=Weighted_Arc_T2P(PN_model,Equal(t),Score(i),1);
    PN_model=Weighted_Arc_T2P(PN_model,Equal(t),Score(k),1);
    t=t+1;
end
end

