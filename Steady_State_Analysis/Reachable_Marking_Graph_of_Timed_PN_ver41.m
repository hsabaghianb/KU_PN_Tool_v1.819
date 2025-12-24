function [PN_model] = Reachable_Marking_Graph_of_Timed_PN_ver41(PN_model, Previous_State, Firing_Tr, Initial_Delay)
    global Max_Sim_Step;
    firing_count=0;
    % Support timed transition  YES 
    %        -State Space in simultanious firing time
    %        -Includes Immediate transition
    % Support timed token       NO
    % Hierarchical simulator    NO
    % Supports inhibitor arcs   YES
    % Priority                  YES (newly addd)

    %TRMG:Timed Reachable Marking Graph is a record of 4 field RM, RMD A and D
    %TRMG.RM: Reachable Marking is a matrix each column is a marking. number of row is equal to number of places
    %TRMG.RMD: Reachable Marking Delay is a matrix. column TRMG.RMD(:,k) corresponds to column TRMG.RM(:,k).
    %          number of row is equal to number of tarnsitions.
    %          each element of a column rpresents time to fire of corresponding transition
    %TRMG.A: Adjacency Matrix. each element A(i,j) corresponds with a transition from state i to state j.  
    %TRMG.D: Delay Matrix. each element D(i,j) represents the state transition delay  from state i to state j.  
    %A(i,j) is a record of Tr and D. Tr is corresponding Transition and D is reminder time to fire of Tr

    if ~all( (PN_model.Tr_Type==0) | (PN_model.Tr_Type==1) ) %if there is any transition which is not timed or immediate  
        disp('''Reachable_Marking_Graph_of_SPN_ver3'' only supports immediate and timed model (a PN model in which transitions are immediate or timed)'); 
    else   
        fir=Firing_Tr;
        nofp=numel(PN_model.P);
        noft=numel(PN_model.T);

        %initialize counters
%         PN_model=Init_Counters(PN_model);
        CountT_backup=PN_model.CountT;

%         Previous_State=1;
        first_time_after_firing=0;
        tick=Initial_Delay;
        end_flag=0;
        while ~end_flag && firing_count<=Max_Sim_Step
            
            old=floor(size(PN_model.TRMG.A,1)/100);
            %generates the vector of  enabled transitions
            for k=1:noft
                x(k)=all(Number_of_Tokens_in_Places(PN_model,PN_model.PPre{k})>=PN_model.Pre_Weight{k})... check if all pre places have enough token? 
                    && all(Number_of_Tokens_in_Places(PN_model,PN_model.InhPPre{k})<PN_model.InhPre_Weight{k})... check if all pre inhibitor places have less than enough token? 
                    && all(Number_of_Tokens_in_Places(PN_model,PN_model.PPost{k})<=PN_model.Cap(PN_model.PPost{k})-PN_model.Post_Weight{k}... check if number of token in all post places will be less or equal
                    | PN_model.Cap(PN_model.PPost{k})==0 );                                                 %their capacites after firing or they hav infinit capacitance?
                %set counter of not enabled transition
                if x(k)==0 
                    PN_model.CountT(k)=PN_model.Delay(k);
                end
            end

            
            if first_time_after_firing
                CountT_backup=PN_model.CountT;
                first_time_after_firing=0;
            end

            if (~any(x)) 
                sprintf('!!!! deadlock');
                CountT_backup(fir)=PN_model.Delay(fir);
                [PN_model.TRMG,end_flag,Previous_State]=Add_New_State_to_TRMG(PN_model,PN_model.TRMG,Previous_State,CountT_backup,fir);
                end_flag=1;                    
                PN_model.TRMG.Last_Marking_If_Deadlock=Previous_State;
            end		
            y=x & (~PN_model.CountT);                  			% y - enabled transition with CountT=0
            
            en_Tr=find(y);
            high_Priority_Tr_logic=(PN_model.Priority(en_Tr)==min(PN_model.Priority(en_Tr)));
            high_Priority_Tr=en_Tr(find(high_Priority_Tr_logic));

            num_of_skip_tick=min(PN_model.CountT(find(x & PN_model.CountT)));
            if numel(num_of_skip_tick)==0 
                num_of_skip_tick=0;
            end

            if (~end_flag && numel(high_Priority_Tr)) 
                CountT_backup(fir)=PN_model.Delay(fir);
                [PN_model.TRMG,end_flag,Previous_State]=Add_New_State_to_TRMG(PN_model,PN_model.TRMG,Previous_State,CountT_backup,fir);
%                 if size(PN_model.TRMG.RM,2)>2 
%                     Draw_TRMG(PN_model.TRMG);
%                 end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %                            Firing all of enabled Transition
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %random selection of transition which fires and fire it 
%                 [m,fir]=max(rand(size(y)).*y+PN_model.Priority.*y);
               CountT_backup=PN_model.CountT;
               temp_M0=PN_model.M0;
               for (fir=high_Priority_Tr)       %Fire all of enabled Transition
                    PN_model.M0=temp_M0;
                    PN_model.CountT=CountT_backup;

                            %                     %Remove Token From All Pre Places
                            %                     GPL_Token=[0,0,0,0];                                %initialize with control token
                            %                     pre=PN_model.PPre{fir};
                            %                     Pre_Weight=PN_model.Pre_Weight{fir};
                            %                     for p=1:numel(pre)
                            %                         if PN_model.Pl_Type(pre(p))==1              %if place is a Data Place(containing GPL)
                            %                             GPL_Token=PN_model.M0{pre(p)}(1);       %copy the data token(soppose that all input data token are the same if not this algorithm should b revised)
                            %                         end
                            %                         PN_model.M0{pre(p)}(1:Pre_Weight(p))=[];
                            %                     end
                            % 
                            %                     %Add Token To All Post Places
                            %                     post=PN_model.PPost{fir};
                            %                     Post_Weight=PN_model.Post_Weight{fir};
                            %                     for p=1:numel(post)
                            %                         if PN_model.Pl_Type(post(p))==1            %if place is a Data Place(containing GPL)
                            %                             for w=1:Post_Weight(p)
                            %                                 PN_model.M0{post(p)}=[PN_model.M0{post(p)},GPL_Token];
                            %                             end
                            %                         else
                            %                             for w=1:Post_Weight(p)
                            %                                 PN_model.M0{post(p)}=[PN_model.M0{post(p)},{[0,0,0,0]}];
                            %                             end
                            %                         end
                            %                     end
                            %                     first_time_after_firing=1;
                
% ---------------------------------------------------------------------------
                ffun_hndl=str2func(PN_model.Firing_func{fir});                 
                [PN_model,Transaction_ID]=ffun_hndl(PN_model,fir);    
% ---------------------------------------------------------------------------
                
                    %set counter of fired transition (after each firing Delay is reinitialized)
                    if (PN_model.Tr_Type(fir)==0)				%Immediat
                        PN_model.CountT(fir)=0;
                    elseif (PN_model.Tr_Type(fir)==1)				%timed
                        PN_model.CountT(fir)=PN_model.Delay(fir);
                    elseif (PN_model.Tr_Type(fir)==2 | PN_model.Tr_Type(fir)==3 | PN_model.Tr_Type(fir)==4)			%stochastic
                        printf('Error in Tr_Type of transition ''%s'' which is 2:Stochastic. \nOnly 0:Immediat or 1:Timed is allowed',PN_model.T(fir));
%                         PN_model.Delay(fir)=exprnd(PN_model.Rate(fir));   
%                         PN_model.CountT(fir)=PN_model.Delay(fir);
                    end

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if (~end_flag && numel(high_Priority_Tr)>1) %if there are simultanious enabled transition call the function for each branch 
                        [PN_model] = Reachable_Marking_Graph_of_Timed_PN_ver4(PN_model, Previous_State, fir, tick);
                    end 
                    firing_count=firing_count+1;
                end
                if numel(high_Priority_Tr)>1 %after performing the last branch, clear fir (the tast fired transition)  
                   fir=[];
                   end_flag=1;
                end
            else
                %changing counters for enabled timed and stochastic transition
                tick=tick+num_of_skip_tick;
                PN_model.CountT=((PN_model.CountT-num_of_skip_tick).*(x & PN_model.Tr_Type)) + (PN_model.CountT.*(~(x & PN_model.Tr_Type)));   
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

