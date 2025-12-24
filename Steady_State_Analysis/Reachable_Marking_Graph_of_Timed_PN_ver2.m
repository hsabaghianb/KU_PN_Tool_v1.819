function [PN_model,TRMG] = Reachable_Marking_Graph_of_Timed_PN_ver2(PN_model,Initial_Delay)
    % Support timed transition  YES
    % Support timed token       NO
    % Hierarchical simulator    NO
    % Supports inhibitor arcs   YES
    % Priority                  NO

    %TRMG:Timed Reachable Marking Graph is a record of 4 field RM, RMD A and D
    %TRMG.RM: Reachable Marking is a matrix each column is a marking. number of row is equal to number of places
    %TRMG.RMD: Reachable Marking Delay is a matrix. column TRMG.RMD(:,k) corresponds to column TRMG.RM(:,k).
    %          number of row is equal to number of tarnsitions.
    %          each element of a column rpresents time to fire of corresponding transition
    %TRMG.A: Adjacency Matrix. each element A(i,j) corresponds with a transition from state i to state j.  
    %TRMG.D: Delay Matrix. each element D(i,j) represents the state transition delay  from state i to state j.  
    %A(i,j) is a record of Tr and D. Tr is corresponding Transition and D is reminder time to fire of Tr

    if any(PN_model.Tr_Type~=1) %if there is a non-stochastic transitions  
        disp('Reachable Marking Graph (RMG)is not available for mixed (Immediate, timed and stochastic) model in this version'); 
        disp('''Reachable_Marking_Graph_of_SPN_ver2'' only supports stochastic model (a PN model in which all transition are stochastic)'); 
        disp('''Reachable_Marking_Graph_of_Timed_PN_ver2'' only supports timed model (a PN model in which all transition are timed)'); 

    elseif all(PN_model.Delay==0) 
        disp('''Reachable_Marking_Graph_of_Timed_PN_ver2'' only supports timed model (a PN model in which all transition are non-zero timed)'); 
        disp('All of timed transition have zero timed delay');
        disp('Please change them to immediate and run it again');
    else   
        fir=[];
        nofp=numel(PN_model.P);
        noft=numel(PN_model.T);

        %initialize counters
        PN_model=Init_Counters(PN_model);
        CountT_backup=PN_model.CountT;

        Previous_State=1;
        first_time_after_firing=0;
        tick=Initial_Delay;
        end_flag=0;
        while ~end_flag %tick<=100 
            %generates the vector of  enabled transitions
            for k=1:noft
            x(k)=all(Number_of_Tokens_in_Places(PN_model,PN_model.PPre{k})>=PN_model.Pre_Weight{k})... check if all pre places have enough token? 
                && all(Number_of_Tokens_in_Places(PN_model,PN_model.InhPPre{k})<PN_model.InhPre_Weight{k})... check if all pre inhibitor places have less than enough token? 
                && all(Number_of_Tokens_in_Places(PN_model,PN_model.PPost{k})<=PN_model.Cap(PN_model.PPost{k})-PN_model.Post_Weight{k}... check if number of token in all post places will be less or equal
                | PN_model.Cap(PN_model.PPost{k})==0 );                                                 %their capacites after firing or they hav infinit capacitance?
        % %         %set again counter of not enabled transition  
        % %         if x(k)==0						
        % %             if (PN_model.Tr_Type(k)==1)			%timed
        % %                 CountT(k)=PN_model.Delay(k);
        % %             elseif (PN_model.Tr_Type(k)==2)			%stochastic
        % %                 CountT(k)=ceil(rand(1)*PN_model.Delay(k));
        % %             end
        % %         end
            end
            if first_time_after_firing
                CountT_backup=PN_model.CountT;
                first_time_after_firing=0;
            end

            if (~any(x)) 
                sprintf('!!!! deadlock');
                end_flag=1;                    
                PN_model.TRMG.Last_Marking_If_Deadlock=Previous_State;
            end		
            y=x & (~PN_model.CountT);                  			% y - enabled transition with CountT=0
            num_of_skip_tick=min(PN_model.CountT(find(x & PN_model.CountT)));

            if (~end_flag && any(y)) 
                [PN_model.TRMG,end_flag,Previous_State]=Add_New_State_to_TRMG(PN_model,PN_model.TRMG,Previous_State,CountT_backup,fir);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %                            Firing just one of enabled Transition
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %random selection of transition which fires and fire it 
                [m,fir]=max(rand(size(y)).*y+PN_model.Priority.*y);

                %Remove Token From All Pre Places
                GPL_Token=[0,0,0,0];                                %initialize with control token
                pre=PN_model.PPre{fir};
                Pre_Weight=PN_model.Pre_Weight{fir};
                for p=1:numel(pre)
                    if PN_model.Pl_Type(pre(p))==1              %if place is a Data Place(containing GPL)
                        GPL_Token=PN_model.M0{pre(p)}(1);       %copy the data token(soppose that all input data token are the same if not this algorithm should b revised)
                    end
                    PN_model.M0{pre(p)}(1:Pre_Weight(p))=[];
                end

                %Add Token To All Post Places
                post=PN_model.PPost{fir};
                Post_Weight=PN_model.Post_Weight{fir};
                for p=1:numel(post)
                    if PN_model.Pl_Type(post(p))==1            %if place is a Data Place(containing GPL)
                        for w=1:Post_Weight(p)
                            PN_model.M0{post(p)}=[PN_model.M0{post(p)},GPL_Token];
                        end
                    else
                        for w=1:Post_Weight(p)
                            PN_model.M0{post(p)}=[PN_model.M0{post(p)},{[0,0,0,0]}];
                        end
                    end
                end
                first_time_after_firing=1;

                %set counter of fired transition - single server semantics
                if (PN_model.Tr_Type(fir)==1)				%timed
                    PN_model.CountT(fir)=PN_model.Delay(fir);
                elseif (PN_model.Tr_Type(fir)==2)			%stochastic
        %                         PN_model.CountT(fir)=ceil(rand(1)*PN_model.Delay(fir));
                    PN_model.Delay(fir)=exprnd(PN_model.Rate(fir));   %after each firing Delay is reinitialized
                    PN_model.CountT(fir)=PN_model.Delay(fir);
                elseif (PN_model.Tr_Type(fir)==3)			%stochastic
                    PN_model.Delay(fir)=normrnd(PN_model.Rate(fir),PN_model.Rate2(fir));   %after each firing Delay is reinitialized
                    PN_model.CountT(fir)=PN_model.Delay(fir);
                elseif (PN_model.Tr_Type(fir)==4)			%stochastic
                    PN_model.Delay(fir)=unifrnd(PN_model.Rate(fir),PN_model.Rate2(fir));   %after each firing Delay is reinitialized
                    PN_model.CountT(fir)=PN_model.Delay(fir);
                end

        % %         %set again counter of fired transition  
        % %         if (PN_model.Tr_Type(fir)==1)			%timed
        % %             CountT(fir)=PN_model.Delay(fir);
        % %         elseif (PN_model.Tr_Type(fir)==2)			%stochastic
        % %             CountT(fir)=ceil(rand(1)*PN_model.Delay(fir));
        % %         end

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            else
                %changing counters for enabled timed and stochastic transition
                tick=tick+num_of_skip_tick;
                PN_model.CountT=((PN_model.CountT-num_of_skip_tick).*(x & PN_model.Tr_Type)) + (PN_model.CountT.*(~(x & PN_model.Tr_Type)));   
                if (any(PN_model.CountT<0)) 
                    sprintf('!!!!negative time');
                end
            end
        end %Main Cycle while 
    end
    TRMG=PN_model.TRMG;
end 

