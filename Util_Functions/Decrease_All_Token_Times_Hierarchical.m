function PN_model=Decrease_All_Token_Times_Hierarchical(PN_model,num_of_skip_tick) 
for p=1:numel(PN_model.P)
    for h=1:numel(PN_model.M0{p})
       if PN_model.M0{p}{h}(4)>=num_of_skip_tick
          PN_model.M0{p}{h}(4)=PN_model.M0{p}{h}(4)-num_of_skip_tick; 
       else
          PN_model.M0{p}{h}(4)=0; 
       end
    end
end
for Tr=1:numel(PN_model.T)
    if numel(PN_model.low_level_model(Tr).T)>0
       PN_model.low_level_model(Tr)=Decrease_All_Token_Times_Hierarchical(PN_model.low_level_model(Tr),num_of_skip_tick);
    end
end
