function PN_model=Decrease_All_Token_Times_Hierarchical_ver2(PN_model,num_of_skip_tick) 
% Tocken delay decrement for mutiple consumer not suported for multiple token in one place when have multiple differnt type consumer Tr
% Also weighted cunsuming is not considered in tocken delay decrement (just all or 1 token decrement is done in this version)
if num_of_skip_tick>0 
    for p=1:numel(PN_model.P)
        Cns=PN_model.Cns{p};
        tkn_cnt=numel(PN_model.M0{p});
        
        if numel(Cns)>1 && tkn_cnt>1 && any(PN_model.Tr_Type(Cns)==0) && ~all(PN_model.Tr_Type(Cns)==0) 
            disp('Tocken delay decrement is not supported for multiple token in one place when have multiple differnt type consumer Tr');
            disp('Check the function ''Decrease_All_Token_Times_Hierarchical_ver2 function');
            pause();
        elseif  all(PN_model.Tr_Type(Cns)~=0)             
            tkn_cnt=min([1,tkn_cnt]);             %just first tokens will be subtracted (Token delay is started for the second tokent after finishing the delay of 1st token)                                               %   subtract num_of_skip_tick of all token delay in the place 
        end                                             
        for h=1:tkn_cnt
           if PN_model.M0{p}{h}(4)>=num_of_skip_tick
              PN_model.M0{p}{h}(4)=PN_model.M0{p}{h}(4)-num_of_skip_tick; 
           else
              PN_model.M0{p}{h}(4)=0; 
           end
        end
    end
    for Tr=1:numel(PN_model.T)
        if numel(PN_model.low_level_model(Tr).T)>0
           PN_model.low_level_model(Tr)=Decrease_All_Token_Times_Hierarchical_ver2(PN_model.low_level_model(Tr),num_of_skip_tick);
        end
    end
end