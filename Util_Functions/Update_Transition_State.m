function [PN_model]=Update_Transition_State(PN_model)
    %-------------------------------------------------
    if isfield(PN_model, 'Required_Resorce_for_Trs')
        Cheking_Tr=1:numel(PN_model.T);
    else
        Cheking_Tr=find(fix(PN_model.Tr_State/8)==1 | (PN_model.Tr_State==3 & PN_model.CountT==0));
    end
    %-------------------------------------------------
    
    for Tr=Cheking_Tr 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        PN_model.Tr_State(Tr)=mod(PN_model.Tr_State(Tr),8);    %%%%%%
        %%%%%%%%%%%%%S%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Post=PN_model.PPost{Tr};
        Pre=PN_model.PPre{Tr};
        PostWt=PN_model.Post_Weight{Tr};
        for indx=1:numel(Post)
            if any(Post(indx)==Pre)
               PostWt(indx)=PostWt(indx)-PN_model.Pre_Weight{Tr}(find(Post(indx)==Pre)); 
            end
        end
%                   && all(Number_of_Tokens_in_Places(PN_model,PN_model.PPost{Tr})<=PN_model.Cap(PN_model.PPost{Tr})-PN_model.Post_Weight{Tr}... check if number of token in all post places will be less or equal
        if numel(PN_model.low_level_model(Tr).T)==0       
            if PN_model.Tr_State(Tr)==0
                PN_model.Tr_State(Tr)=all(Number_of_Tokens_in_Places(PN_model,PN_model.PPre{Tr})>=PN_model.Pre_Weight{Tr})... check if all pre places have enough token? 
                  && all(Number_of_Tokens_in_Places(PN_model,PN_model.InhPPre{Tr})<PN_model.InhPre_Weight{Tr})... check if all pre inhibitor places have less than enough token? 
                  && all(Number_of_Tokens_in_Places(PN_model,PN_model.PPost{Tr})<=PN_model.Cap(PN_model.PPost{Tr})-PostWt... check if number of token in all post places will be less or equal
                     | PN_model.Cap(PN_model.PPost{Tr})==0);                                                  %their capacites after firing or they have infinit capacitance?
%                  if ~(isfield(PN_model, 'Required_Resorce_for_Trs') && PN_model.Runing(Tr)==1)
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    PN_model.Tr_State(Tr)=PN_model.Tr_State(Tr)*7;     %%%%%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  else
%                      'stop'
%                  end
            else
                PN_model.Tr_State(Tr)=7;
            end 
            %for timed and stochastic transition check the time of pre places token(All should be zero)
            if PN_model.Tr_State(Tr)==7 && PN_model.Tr_Type(Tr)~=0   %if transition is stochastic or timed and has priliminary condition of enabling 
                if ~isfield(PN_model, 'Required_Resorce_for_Trs')
                    pre=PN_model.PPre{Tr};
                    for h=1:numel(pre)
%                        if numel(PN_model.M0{pre(h)})==0
%                           'stop' 
%                        end
                       if PN_model.M0{pre(h)}{1}(4)>0 
                          %remove the transition from enableing list if at least one pre token has non-zero time
                          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                          PN_model.Tr_State(Tr)=5;    %%%%%%
                          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                       end
                    end
                end
                if PN_model.CountT(Tr)~=0    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    PN_model.Tr_State(Tr)=PN_model.Tr_State(Tr)-4;      %%%%%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                end
            end

            %set counter of not enabled transition
            if PN_model.Tr_State(Tr)==0 || PN_model.Tr_State(Tr)==1 || PN_model.Tr_State(Tr)==5
                if numel(PN_model.low_level_model(Tr).T)>0
                    PN_model.low_level_model(Tr)=Init_Counters(PN_model.low_level_model(Tr));
                elseif (PN_model.Tr_Type(Tr)>=1 && PN_model.Tr_Type(Tr)<=4)			%timed and stochastic
                    PN_model.CountT(Tr)=PN_model.Delay(Tr);
%                 elseif (PN_model.Tr_Type(Tr)==2)			%stochastic exponential
%                     PN_model.CountT(Tr)=PN_model.Delay(Tr); %at first in creation of Transition and after each firing Delay is reinitialized
                                                            %Delays have been set by PN_model.Delay(Tr)=exprnd(1/PN_model.Rate(Tr)) for type 2;
                end
            end
        
        else %numel(PN_model.low_level_model(Tr).T)>0
            
            %Check equvalence of high and low level marking 
            if check_marking_up_PN(PN_model,Tr) || check_marking_down_PN(PN_model,Tr)
               PN_model.Tr_State(Tr)=7; 
            end

            %Check if low level model has any enabled intrnal enabled transition
            if PN_model.Tr_State(Tr)==0 
                [PN_model.low_level_model(Tr),Fir_Lst,deadlock_LowLvl]=Find_Enabled_Transition_Hierarchical_Fast(PN_model);

                if numel(find(Fir_Lst))>0
                   PN_model.Tr_State(Tr)=7; 
                end
            end            
        end
    end
    PN_model.Enabled_Tr=PN_model.Tr_State==7 | PN_model.Tr_State==3;   %some other functions (like Decrease_All_Counters_Hierarchical.m) that are used by old function may need PN_model.Enabled_Tr 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    