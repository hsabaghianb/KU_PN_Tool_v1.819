function [PN_model] = Reachable_Marking_Graph_of_SPN_ver4(PN_model, Previous_State, Firing_Tr)
% This function is a revised version of "Reachable_Marking_Graph_of_Timed_PN_ver2" 
% which is developed for Stochastic PN, Probabilistic PN and ordinary PN

% Support timed transition  NO
% Support timed token       NO
% Hierarchical simulator    NO
% Supports inhibitor arcs   YES
% Priority                  YES (newly addd)

%RMG:Reachable Marking Graph is a record of 3 field RM, A and R for SPN and 2 field RM and A for ordinary PN
%RMG.RM: Reachable Marking is a matrix each column is a marking. number of row is equal to number of places
%RMG.A: Adjacency Matrix. each element A(i,j) corresponds with a transition from state i to state j.  
%RMG.R: Rate Matrix (just for SPN). each R(i,j) represents the state transition Rate from state i to state j.  

if ~all( (PN_model.Tr_Type==0) | (PN_model.Tr_Type==2) ) %if there is a transition which is not stochastic or immediate
    disp('Reachable Marking Graph (RMG)is only available for Immediate and Stochastic model or mix of them in this version'); 
else 
    fir=Firing_Tr;
    noft=numel(PN_model.T);
    end_flag=0;
    %generates an array of enabled transitions named x
    for k=1:noft
        x(k)=all(Number_of_Tokens_in_Places(PN_model,PN_model.PPre{k})>=PN_model.Pre_Weight{k})... check if all pre places have enough token? 
            && all(Number_of_Tokens_in_Places(PN_model,PN_model.InhPPre{k})<PN_model.InhPre_Weight{k})... check if all pre inhibitor places have less than enough token? 
            && all(Number_of_Tokens_in_Places(PN_model,PN_model.PPost{k})<=PN_model.Cap(PN_model.PPost{k})-PN_model.Post_Weight{k}... check if number of token in all post places will be less or equal
            | PN_model.Cap(PN_model.PPost{k})==0 );                                                 %their capacites after firing or they hav infinit capacitance?
    end
    x=x & (PN_model.ProbWeight~=0); %remove enable tr if the probability its weight is 0 
    if (~any(x)) 
        [PN_model.RMG,end_flag,Previous_State]=Add_New_State_to_RMG(PN_model,PN_model.RMG,Previous_State,fir,[]); 
        sprintf('!!!! deadlock');
        end_flag=1;
    else
            en_Tr=find(x);
            
            Imm_Tr_logic=(PN_model.Tr_Type(en_Tr)==0);  %check if there are Imm Tr remove all other type of Tr 
            if any(Imm_Tr_logic)
               en_Tr=en_Tr(Imm_Tr_logic);    
            end
            
            high_Priority_Tr_logic=(PN_model.Priority(en_Tr)==min(PN_model.Priority(en_Tr)));
            high_Priority_Tr=en_Tr(high_Priority_Tr_logic);
            
        [PN_model.RMG,end_flag,Previous_State]=Add_New_State_to_RMG(PN_model,PN_model.RMG,Previous_State,fir,high_Priority_Tr);
        if (~end_flag)          %if current state is a new state  
            
            temp_M0=PN_model.M0;
            temp_ProbWeight=PN_model.ProbWeight;
            temp_Rate=PN_model.Rate;
            for fir=high_Priority_Tr       %Fire all of enabled Transition
                PN_model.M0=temp_M0;
                PN_model.ProbWeight=temp_ProbWeight;
                PN_model.Rate=temp_Rate;
                            %                 %Remove Token From All Pre Places
                            %                 GPL_Token=[0,0,0,0];                                %initialize with control token
                            %                 pre=PN_model.PPre{fir};
                            %                 Pre_Weight=PN_model.Pre_Weight{fir};
                            %                 for p=1:numel(pre)
                            %                     if PN_model.Pl_Type(pre(p))==1              %if place is a Data Place(containing GPL)
                            %                         GPL_Token=PN_model.M0{pre(p)}(1);       %copy the data token(soppose that all input data token are the same if not this algorithm should b revised)
                            %                     end
                            %                     PN_model.M0{pre(p)}(1:Pre_Weight(p))=[];
                            %                 end
                            % 
                            %                 %Add Token To All Post Places
                            %                 post=PN_model.PPost{fir};
                            %                 Post_Weight=PN_model.Post_Weight{fir};
                            %                 for p=1:numel(post)
                            %                     if PN_model.Pl_Type(post(p))==1            %if place is a Data Place(containing GPL)
                            %                         for w=1:Post_Weight(p)
                            %                             PN_model.M0{post(p)}=[PN_model.M0{post(p)},GPL_Token];
                            %                         end
                            %                     else
                            %                         for w=1:Post_Weight(p)
                            %                             PN_model.M0{post(p)}=[PN_model.M0{post(p)},{[0,0,0,0]}];
                            %                         end
                            %                     end
                            %                 end
% ---------------------------------------------------------------------------
                ffun_hndl=str2func(PN_model.Firing_func{fir});                 
                [PN_model,Transaction_ID]=ffun_hndl(PN_model,fir);    
% ---------------------------------------------------------------------------

                PN_model = Reachable_Marking_Graph_of_SPN_ver4(PN_model, Previous_State, fir);
            end %for
        else
            f=1;
        end %if
    end 
end
