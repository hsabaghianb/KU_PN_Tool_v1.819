function [PN_model,Firing_List,deadlock]=Find_Enabled_Transition_Hierarchical_Fast(PN_model)
global Num_of_Checked_Tr; 
Num_of_Checked_Tr=Num_of_Checked_Tr+numel(find(fix(PN_model.Tr_State/8)==1));
%     uncheked=numel(find(fix(PN_model.Tr_State/8)==1));
    [PN_model]=Update_Transition_State(PN_model);
    Firing_List=PN_model.Tr_State==7;
    deadlock=all(PN_model.Tr_State==0);
%     uncheked/numel(find(Firing_List))
end