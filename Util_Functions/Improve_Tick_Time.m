function [PN_model,tick]=Improve_Tick_Time(PN_model,tick,num_of_skip_tick)
tick=tick+num_of_skip_tick;
% tick=tick+1;
PN_model=Decrease_All_Token_Times_Hierarchical(PN_model,num_of_skip_tick); 
PN_model=Decrease_All_Counters_Hierarchical(PN_model,num_of_skip_tick); 
