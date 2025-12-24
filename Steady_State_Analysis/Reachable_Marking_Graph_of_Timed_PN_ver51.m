function [PN_model] = Reachable_Marking_Graph_of_Timed_PN_ver51(PN_model, Previous_State, fir, time2fire, Initial_Delay)
    global Max_Sim_Step;
    firing_count=0;
    % Support timed transition  YES 
    %        -State Space in simultanious firing time
    %        -Includes Immediate transition
    % Support timed token       YES (newly addd)
    % Hierarchical simulator    NO
    % Supports inhibitor arcs   YES
    % Priority                  YES 

    %TRMG:Timed Reachable Marking Graph is a record of 4 field RM, RMD A and D
    %TRMG.RM: Reachable Marking is a matrix each column is a marking. number of row is equal to number of places
    %TRMG.RMD: Reachable Marking Delay is a matrix. column TRMG.RMD(:,k) corresponds to column TRMG.RM(:,k).
    %          number of row is equal to number of tarnsitions.
    %          each element of a column rpresents time to fire of corresponding transition
    %TRMG.A: Adjacency Matrix. each element A(i,j) corresponds with a transition from state i to state j.  
    %TRMG.D: Delay Matrix. each element D(i,j) represents the state transition delay  from state i to state j.  
    %A(i,j) is a record of Tr and D. Tr is corresponding Transition and D is reminder time to fire of Tr
    
    
    if ~all( (PN_model.Tr_Type==0) | (PN_model.Tr_Type==1) ) %if there is any transition which is not "timed or immediate"  
        disp('''Reachable_Marking_Graph_of_Timed_PN_ver51'' only supports immediate and timed model (a PN model in which transitions are immediate or timed)'); 
    else   
        if numel(fir)==0 
            PN_model.temp_tick=Initial_Delay;
        end
        nofp=numel(PN_model.P);
        noft=numel(PN_model.T);

        tick=Initial_Delay;
        end_flag=0;
        while (~end_flag) && firing_count<=Max_Sim_Step
            
            old=floor(size(PN_model.TRMG.A,1)/100);
            %generates the vector of  enabled transitions
            num_of_skip_tick=[];
            
            x=zeros(1,numel(PN_model.T));
            xx=x;
            TrCapSat=ones(1,numel(PN_model.T));
            
            for k=1:noft
                x(k)=all(Number_of_Tokens_in_Places(PN_model,PN_model.PPre{k})>=PN_model.Pre_Weight{k})... %check if all pre places have enough token? 
                    && all(Number_of_Tokens_in_Places(PN_model,PN_model.InhPPre{k})<PN_model.InhPre_Weight{k}); %check if all pre inhibitor places have less than enough token? 
%                     && all(Number_of_Tokens_in_Places(PN_model,PN_model.PPost{k})<=PN_model.Cap(PN_model.PPost{k})-PN_model.Post_Weight{k}... check if number of token in all post places will be less or equal
%                     | PN_model.Cap(PN_model.PPost{k})==0 );                                                 %their capacites after firing or they hav infinit capacitance?
                xx(k)=x(k);
                
                % % % % % % % % % % % % % % % % % % % % % % % % % % % 
                %for timed and stochastic transition check the time of pre places token(All should be zero)
                if x(k) && PN_model.Tr_Type(k)~=0   %if transition is stochastic or timed and has priliminary condition of enabling 
                    pre=PN_model.PPre{k};
                    PreWght=PN_model.Pre_Weight{k};
                    for h=1:numel(pre)
                       for w=1:PreWght(h) 
                           if PN_model.M0{pre(h)}{w}(4)>0 
                              xx(k)=0;                   %remove the transition from enableing list if at least one pre token has non-zero time                
                              if numel(num_of_skip_tick)==0
                                  num_of_skip_tick=PN_model.M0{pre(h)}{w}(4);
                              elseif PN_model.M0{pre(h)}{w}(4)<num_of_skip_tick
                                  num_of_skip_tick=PN_model.M0{pre(h)}{w}(4);
                              end
                           end
                       end
                    end
                    SLCPPW=zeros(1,numel(PN_model.PPost{k}));   % Pre Places Weight Corresponding to the post places weight if there is Self Loop if no 0 weight 
                    for c=1:numel(PN_model.PPost{k})
                        iidx=find(PN_model.PPre{k}==PN_model.PPost{k}(c));
                        if numel(iidx)>0
                            SLCPPW(c)=PN_model.Pre_Weight{k}(iidx);
                        else
                            SLCPPW(c)=0;
                        end
                    end
                    
                    if ~(all(Number_of_Tokens_in_Places(PN_model,PN_model.PPost{k}) <= PN_model.Cap(PN_model.PPost{k})-PN_model.Post_Weight{k}+SLCPPW... %check if number of token in all post places is less or equal
                                                                                                   | PN_model.Cap(PN_model.PPost{k})==0 ))      %their capacites after firing or they have infinit capacitance?
                        xx(k)=0;
                        TrCapSat(k)=0;    %Transition Capcity Satisfy
                    end
                end
                % % % % % % % % % % % % % % % % % % % % % % % % % % %   
                
                %set counter of not enabled transition
                if x(k)==0 
                    PN_model.CountT(k)=PN_model.Delay(k);
                end
            end

            if (~any(x & TrCapSat)) 
                sprintf('!!!! deadlock');
%                 CountT_backup(fir)=PN_model.Delay(fir);
                [PN_model.TRMG,end_flag,Previous_State]=Add_New_State_to_TRMG_ver5(PN_model,PN_model.TRMG,Previous_State,fir,time2fire);
                end_flag=1;                    
                PN_model.TRMG.Last_Marking_If_Deadlock=Previous_State;
            end		
            y=x & (~PN_model.CountT) & xx;                  			% y - enabled transition with CountT=0

            en_Tr=find(y);
            high_Priority_Tr_logic=(PN_model.Priority(en_Tr)==min(PN_model.Priority(en_Tr)));
            high_Priority_Tr=en_Tr(find(high_Priority_Tr_logic));

            % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
            num_of_skip_tick=min([min(PN_model.CountT(find(x & PN_model.CountT))),num_of_skip_tick]);
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
            if numel(num_of_skip_tick)==0 
                num_of_skip_tick=0;
            end

            if (~end_flag && numel(high_Priority_Tr)) 
                [PN_model.TRMG,end_flag,Previous_State]=Add_New_State_to_TRMG_ver5(PN_model,PN_model.TRMG,Previous_State,fir,time2fire);
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %                            Firing all of enabled Transition
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                temp_M0=PN_model.M0;
                CountT_backup=PN_model.CountT;
                time2fire=tick-PN_model.temp_tick;
                PN_model.temp_tick=tick;
                for (fir=high_Priority_Tr)       %Fire all of enabled Transition
                    PN_model.M0=temp_M0;
                    PN_model.CountT=CountT_backup;
                    tick=PN_model.temp_tick;
               
                    % ---------------------------------------------------------------------------
                    ffun_hndl=str2func(PN_model.Firing_func{fir});                 
                    [PN_model,Transaction_ID]=ffun_hndl(PN_model,fir); 
                    % ---------------------------------------------------------------------------

                    %set counter of fired transition (after each firing Delay is reinitialized)
                    if (PN_model.Tr_Type(fir)==0)                   %Immediat
                        PN_model.CountT(fir)=0;
                    elseif (PN_model.Tr_Type(fir)==1)				%timed
                        PN_model.CountT(fir)=PN_model.Delay(fir);
                        
                    % ------------------------------------------------------------------------------------------------------------
                    % ------------- Reinitialize counter of transition with common pre places if needed --------------------------
                    % ---------------------------- the code should be writen -----------------------------------------------------         
                    Ppre=PN_model.PPre{fir};
                    Post=PN_model.PPost{fir};
                    for PPidx=1:numel(Ppre)
                        if numel(PN_model.Cns{Ppre(PPidx)})>1
%                             NoCnsTkn=PN_model.Pre_Weight{fir}(PPidx);  %number of consumed token by transition fir
                            NoPrdTkn=0;
                            OutArcInxOfTrSlfLoop=find(Post==Ppre(PPidx));
                            if numel(OutArcInxOfTrSlfLoop)>0   %if there is any self loop for the place Ppre(PPidx) by the transition fir
                               NoPrdTkn=PN_model.Pre_Weight{fir}(PPidx); %number of produced token from the place Ppre(PPidx) by transition fir
                            end
                            CCns=PN_model.Cns{Ppre(PPidx)};
                            CCns(CCns==fir)=[];
                            for cc=CCns
                                CnsIdx=find(PN_model.PPre{cc}==Ppre(PPidx));
                                if Number_of_Tokens_in_Places(PN_model, Ppre(PPidx))-NoPrdTkn < PN_model.Pre_Weight{cc}(CnsIdx)
                                   if (PN_model.Tr_Type(cc)==0)                 %Immediat
                                       PN_model.CountT(cc)=0;
                                   elseif (PN_model.Tr_Type(cc)==1)				%timed
                                       PN_model.CountT(cc)=PN_model.Delay(cc); 
                                   end
                                end
                            end
                            
                        end
                    end
                    % ------------------------------------------------------------------------------------------------------------
                        
                    elseif (PN_model.Tr_Type(fir)==2)               %stochastic
                        printf('Error in Tr_Type of transition ''%s'' which is 2:Stochastic. \nOnly 0:Immediat or 1:Timed is allowed',PN_model.T(fir));
                    end

                    if (~end_flag && numel(high_Priority_Tr)>1) %if there are simultanious enabled transition call the function for each branch 
                        [PN_model] = Reachable_Marking_Graph_of_Timed_PN_ver51(PN_model, Previous_State, fir, time2fire, tick);
                    end 
                    firing_count=firing_count+1;
                end
                if numel(high_Priority_Tr)>1 %after performing the last branch, clear fir (the tast fired transition)  
                   fir=[];
                   end_flag=1;
                end
            else
                %Improve tick time 
                tick=tick+num_of_skip_tick;
              
                % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
                % Update tocken delays 
                PN_model=Decrease_All_Token_Times_Hierarchical_ver2(PN_model,num_of_skip_tick); 
                                
                % changing counters for enabled timed and stochastic transition
                PN_model.CountT=((PN_model.CountT-num_of_skip_tick).*(x & PN_model.Tr_Type & PN_model.CountT>=num_of_skip_tick))...   
                                +(0.*(x & PN_model.Tr_Type & PN_model.CountT<num_of_skip_tick))...
                                + (PN_model.CountT.*(~(x & PN_model.Tr_Type)));  
                % Decrease_All_Counters_Hierarchical(PN_model,num_of_skip_tick); 
                % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
                
                if (any(PN_model.CountT<0)) 
                    sprintf('!!!!negative time');
                end
            end
        end %Main Cycle while 
        if ~end_flag
           disp('Error!: Number of firing transition exceeded Max_Sim_Step'); 
        end
    end
   
end 

