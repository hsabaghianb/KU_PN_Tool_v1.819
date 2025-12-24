function PN_model=Decrease_All_Counters_Hierarchical(PN_model,num_of_skip_tick)
% if numel(PN_model.Enabled_Tr)==0
%     PN_model.Enabled_Tr=zeros(1,numel(PN_model.T));
% end
Enable_Timed_Tr=PN_model.Enabled_Tr==1 & PN_model.Tr_Type;
Should_Get_Zero=Enable_Timed_Tr & PN_model.CountT<num_of_skip_tick;
Should_be_decrement=Enable_Timed_Tr & PN_model.CountT>=num_of_skip_tick;
if any (Should_Get_Zero)
   'Error:num_of_skip_tick is too big' 
end
%==================================================================================================================================
if isfield(PN_model, 'Required_Resorce_for_Trs') %added for resource PN model
    temp_list=find(Should_be_decrement);                                        %     temp_list=Should_be_decrement
    while numel(temp_list)>0                                                    %     while temp_list not empty
         highest_Priority=(PN_model.Priority(temp_list)==min(PN_model.Priority(temp_list))); %         select highest priority members of list
         highest_Priority=temp_list(highest_Priority);
         ptr=Weighted_Random(PN_model.ProbWeight(highest_Priority));            %         select one of the highest priority randomley
         selected=highest_Priority(ptr);
         if PN_model.Delay(selected)==PN_model.CountT(selected)                 %         if delay=count check %first time to decrement 
            if all(PN_model.Required_Resorce_for_Trs(selected,:)<= PN_model.R)...  %             if the required resource is availabe 
               && all(Number_of_Tokens_in_Places(PN_model,PN_model.PPre{selected})>=PN_model.Pre_Weight{selected})
               pre=PN_model.PPre{selected};                                     %                 remove tokens from input places  
               Pre_Weight=PN_model.Pre_Weight{selected};
               for p=1:numel(pre)
                   if numel(PN_model.M0{pre(p)})>=Pre_Weight(p)
                      PN_model.M0{pre(p)}(1:Pre_Weight(p))=[];
                   else
                       'stop'
                   end
               end
               PN_model.R=PN_model.R-PN_model.Required_Resorce_for_Trs(selected,:);%              catch and update resources
               PN_model.Runing(selected)=1;
            else                                                                %             else
               Should_be_decrement(selected)=0;                                 %                 remove that Tr from Should_be_decrement
            end                                                                 %             end
         end                                                                    %         end
         temp_list(temp_list==selected)=[];                                     %         remove selected from the temp_list
    end                                                                         %     end
    decrement_list=find(Should_be_decrement);
    for Tr=decrement_list                                                       %     for each Should_be_decrement Trs 
        if PN_model.CountT(Tr)==num_of_skip_tick                                %         check if count=num_of_skip_tick  %last time to decrement 
            pre=PN_model.PPre{Tr};                                              %            return removed tokens back to the input places (when fired it will be removed again)  
            Pre_Weight=PN_model.Pre_Weight{Tr};
            for p=1:numel(pre)
                PN_model.M0{pre(p)}=[repmat({[0,0,0,0]},1,Pre_Weight(p)),PN_model.M0{pre(p)}];
            end
            PN_model.R=PN_model.R+PN_model.Required_Resorce_for_Trs(Tr,:);        %            release and update resources
            PN_model.Runing(Tr)=0;
        end                                                                     %         end
    end                                                                         %     end
end
%==================================================================================================================================
PN_model.CountT=((PN_model.CountT-num_of_skip_tick).*(Should_be_decrement)) + (PN_model.CountT.*(~Should_be_decrement)); 
PN_model.CountT=PN_model.CountT.*(~Should_Get_Zero); 
for Tr=1:numel(PN_model.T)
    if numel(PN_model.low_level_model(Tr).T)>0
       PN_model.low_level_model(Tr)=Decrease_All_Counters_Hierarchical(PN_model.low_level_model(Tr),num_of_skip_tick);
    end
end

