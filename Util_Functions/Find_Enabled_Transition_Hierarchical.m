function [PN_model,Firing_List,deadlock,num_of_skip_tick]=Find_Enabled_Transition_Hierarchical(PN_model,num_of_skip_tick)
	%generation of vector of  enabled transitions
    deadlock=1;
    notr=numel(PN_model.T);
    Enabled(1:notr)=0;
%     hot_Tr=Find_Hot_Tr(PN_model);
% 	hot_Tr=hot_Tr & (~PN_model.CountT);                  			
    for Tr=1:notr
%     for Tr=hot_Tr
        if numel(PN_model.low_level_model(Tr).T)==0
        
%             Looked_Enable(Tr)=all(Number_of_Tokens_in_Places(PN_model,PN_model.PPre{Tr})>0)... check if all pre places have token? 
%                 && all(Number_of_Tokens_in_Places(PN_model,PN_model.PPost{Tr})<PN_model.Cap(PN_model.PPost{Tr}) ...check if number of token in all post places ar less than their capacites
%                 | PN_model.Cap(PN_model.PPost{Tr})==0 );                         %or capasity is unlimited
    
            Looked_Enable(Tr)=all(Number_of_Tokens_in_Places(PN_model,PN_model.PPre{Tr})>=PN_model.Pre_Weight{Tr})... check if all pre places have enough token? 
              && all(Number_of_Tokens_in_Places(PN_model,PN_model.InhPPre{Tr})<PN_model.InhPre_Weight{Tr})... check if all pre inhibitor places have less than enough token? 
              && all(Number_of_Tokens_in_Places(PN_model,PN_model.PPost{Tr})<=PN_model.Cap(PN_model.PPost{Tr})-PN_model.Post_Weight{Tr}... check if number of token in all post places will be less or equal
                 | PN_model.Cap(PN_model.PPost{Tr})==0 );                                                 %their capacites after firing or they have infinit capacitance?

            if any(Looked_Enable)
                deadlock=0; 
            end
            
            Enabled(Tr)=Looked_Enable(Tr);
            %for timed and stochastic transition check the time of pre places token(All should be zero)
            if Enabled(Tr) && PN_model.Tr_Type(Tr)~=0   %if transition is stochastic or timed and has priliminary condition of enabling 
                pre=PN_model.PPre{Tr};
                for h=1:numel(pre)
                   if PN_model.M0{pre(h)}{1}(4)>0 
                      Enabled(Tr)=0;                   %remove the transition from enableing list if at least one pre token has non-zero time
                      if numel(num_of_skip_tick)==0
                          num_of_skip_tick=PN_model.M0{pre(h)}{1}(4);
                      elseif PN_model.M0{pre(h)}{1}(4)<num_of_skip_tick
                          num_of_skip_tick=PN_model.M0{pre(h)}{1}(4);
                      end
                   end
                end
            end

            %set counter of not enabled transition
            if Enabled(Tr)==0 
                if numel(PN_model.low_level_model(Tr).T)>0
                    PN_model.low_level_model(Tr)=Init_Counters(PN_model.low_level_model(Tr));
                elseif (PN_model.Tr_Type(Tr)==1)			%timed
                    PN_model.CountT(Tr)=PN_model.Delay(Tr);
                elseif (PN_model.Tr_Type(Tr)==2)			%stochastic exponential
                    PN_model.CountT(Tr)=PN_model.Delay(Tr); %at first in creation of Transition and after each firing Delay is reinitialized
                                                            %Delays have been set by PN_model.Delay(Tr)=exprnd(1/PN_model.Rate(Tr));
                end
            end
        
        else %numel(PN_model.low_level_model(Tr).T)>0
            %Check equvalence of high and low level marking 
            if check_marking_up_PN(PN_model,Tr) || check_marking_down_PN(PN_model,Tr)
               Enabled(Tr)=1; 
            end


            %Check if low level model has any enabled intrnal enabled transition
            if Enabled(Tr)==0 
                [PN_model.low_level_model(Tr),Fir_Lst,deadlock_LowLvl,num_of_skip_tick]=Find_Enabled_Transition_Hierarchical(PN_model.low_level_model(Tr),num_of_skip_tick);
                if numel(find(Fir_Lst))>0
%                     fprintf('\n%s',PN_model.T{Tr})
                   Enabled(Tr)=1; 
                end
                if ~deadlock_LowLvl 
                   deadlock=0; 
                end
            end
            
            if any(Enabled)
                deadlock=0; 
            end
            
        end
            

    end
% 	if any(Looked_Enable)
%         deadlock=0;
% 	end		
	Firing_List=Enabled & (~PN_model.CountT);                  			% Firing_List - Enabled transition with PN_model.CountT=0
    num_of_skip_tick=min([min(PN_model.CountT(find(Enabled & PN_model.CountT))),num_of_skip_tick]);
    PN_model.Enabled_Tr=Enabled;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    