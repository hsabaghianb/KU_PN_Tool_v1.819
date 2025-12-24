
function PN_model=consensus()

%Make null PN model
[PN_model] = Init_PN('consensus');

%Define Places
%---------------------------------------------------------------
% [PN_model,Pl_num]=New_Place(PN_model,Name,Cap,Type,Marking)
%---------------------------------------------------------------
for i=1:16 
    [PN_model,p(i)]=New_Place(PN_model,['P',num2str(i)],0,1,{[1,i,0,0]});
end

%Define Transitions
%---------------------------------------------------------------
%[PN_model,Tr_num]=New_Transition(PN_model, Name, Firing_func_name, 
%   Type=0/1/2, TrValue=0/TrDly/Rate, TknDly, Priority, Probability)
%Type=0:Immediate 1:Timed 2:Stochastic 
%---------------------------------------------------------------
for i=1:8 
    [PN_model,t(i)]=New_Transition(PN_model,['T',num2str(i)], 'General_func',0,1,0,1,1);
    PN_model=Weighted_Arc_P2T(PN_model,p(2*i-1),t(i),1);
    PN_model=Weighted_Arc_T2P(PN_model,t(i),p(2*i),1);
end;    
for i=1:4 
    [PN_model,t(8+i)]=New_Transition(PN_model,['T',num2str(8+i)], 'General_func',0,1,0,1,1);
    PN_model=Weighted_Arc_P2T(PN_model,p(4*i-2),t(8+i),2);
    PN_model=Weighted_Arc_T2P(PN_model,t(8+i),p(4*i),2);
end;    
for i=1:2 
    [PN_model,t(12+i)]=New_Transition(PN_model,['T',num2str(12+i)], 'General_func',0,1,0,1,1);
    PN_model=Weighted_Arc_P2T(PN_model,p(8*i-4),t(12+i),4);
    PN_model=Weighted_Arc_T2P(PN_model,t(12+i),p(8*i),4);
end;   
for i=1:1 
    [PN_model,t(14+i)]=New_Transition(PN_model,['T',num2str(14+i)], 'General_func',0,1,0,1,1);
    PN_model=Weighted_Arc_P2T(PN_model,p(16*i-8),t(14+i),8);
    PN_model=Weighted_Arc_T2P(PN_model,t(14+i),p(16*i),8);
end;   




