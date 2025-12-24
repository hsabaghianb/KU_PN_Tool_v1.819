function [PN_model,num_of_skip_tick]=Time_to_Next_Event(PN_model)
     index=[];
     num_of_skip_tick=Inf;
     All_Dlyed_Tr=find(PN_model.Tr_State==1 | PN_model.Tr_State==3 | PN_model.Tr_State==5);
     for Tr=All_Dlyed_Tr
         pre=PN_model.PPre{Tr};
         tkn_dly=0;
         if isfield(PN_model, 'SelfService') && PN_model.SelfService(Tr)==1
             if numel(pre)==1
                 tkn_dly=Inf;
                 for h=1:numel(PN_model.M0{pre(1)})
                     if PN_model.M0{pre(1)}{h}(4)<tkn_dly  
                         tkn_dly=PN_model.M0{pre(1)}{h}(4);
                         Min_Time_Token=PN_model.M0{pre(1)}{h};
                         Min_Time_Token_ptr=h;
                     end
                 end 
                 PN_model.M0{pre(1)}(Min_Time_Token_ptr)=[];
                 PN_model.M0{pre(1)}=[Min_Time_Token,PN_model.M0{pre(1)}];
             else
                printf("Error in transition %d: Only one input place is allowed for SelfService transition ", Tr);
             end
         elseif ~(isfield(PN_model, 'Required_Resorce_for_Trs') && any(PN_model.Required_Resorce_for_Trs(Tr,:)>0))
             for h=1:numel(pre)
                 tkn_dly=max([tkn_dly, PN_model.M0{pre(h)}{1}(4)]);
             end
         end
         
         if PN_model.Tr_State(Tr)==1
             required_delay(Tr)=tkn_dly+PN_model.CountT(Tr);
         elseif PN_model.Tr_State(Tr)==3
             required_delay(Tr)=PN_model.CountT(Tr);
         elseif PN_model.Tr_State(Tr)==5
             required_delay(Tr)=tkn_dly;
         end
         if required_delay(Tr)<num_of_skip_tick
             num_of_skip_tick=required_delay(Tr);
             indx=Tr;
         end
     end
     if num_of_skip_tick<Inf
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         PN_model.Tr_State(indx)=mod(PN_model.Tr_State(indx),8)+8;    %%%%%%    %set state to unchecked
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     end
end
 




% Old Version

% function [PN_model,num_of_skip_tick]=Time_to_Next_Event(PN_model)
%      required_delay=ones(1,numel(PN_model.T)) * max(PN_model.CountT);
%      All_Dlyed_Tr=find(PN_model.Tr_State==1 | PN_model.Tr_State==3 | PN_model.Tr_State==5);
%      for Tr=All_Dlyed_Tr
%          pre=PN_model.PPre{Tr};
%          tkn_dly=0;
%          for h=1:numel(pre)
%              tkn_dly=max([tkn_dly, PN_model.M0{pre(h)}{1}(4)]);
%          end
%          
%          if PN_model.Tr_State(Tr)==1
%              required_delay(Tr)=tkn_dly+PN_model.CountT(Tr);
%          elseif PN_model.Tr_State(Tr)==3
%              required_delay(Tr)=PN_model.CountT(Tr);
%          elseif PN_model.Tr_State(Tr)==5
%              required_delay(Tr)=tkn_dly;
%          end
%      end
%      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      [num_of_skip_tick,indx]=min(required_delay);                 %%%%%%
%      PN_model.Tr_State(indx)=mod(PN_model.Tr_State(indx),8)+8;    %%%%%%    %set state to unchecked
%      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%  end
