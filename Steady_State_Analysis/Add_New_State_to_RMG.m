function [RMG,end_flag,Previous_State]=Add_New_State_to_RMG(PN_model,RMG,Previous_State,fired,Enabled_Tr)
    Enabled_Tr_Logic=zeros(1,numel(PN_model.T)); 
    Enabled_Tr_Logic(Enabled_Tr)=1;
    end_flag=0;
    if size(RMG.RM,2)<10000
        Cur_Marking=Number_of_Tokens_in_Places(PN_model,1:numel(PN_model.P)); 
        RMG.RM=[RMG.RM,Cur_Marking'];              %Add marking to RM
        RMG.RMP=[RMG.RMP,PN_model.ProbWeight'];    %Add Transition ProbWeight to RMP
        RMG.RMR=[RMG.RMR,PN_model.Rate'];          %Add Transition Rate to RMR
        RMG.EnTr=[RMG.EnTr,Enabled_Tr_Logic'];     %Add Enabled Transition at the current state
        if size(RMG.RM,2)>1 && numel(fired)>0
            Compare_RM_Mat= RMG.RM(:,1:end-1)==repmat(RMG.RM(:,end),1,size(RMG.RM,2)-1);
%             Compare_RMR_Mat= RMG.RMR(:,1:end-1)==repmat(RMG.RMR(:,end),1,size(RMG.RMR,2)-1);
            Compare_RMR_Mat= abs((repmat(RMG.RMR(:,end),1,size(RMG.RMR,2)-1))-(RMG.RMR(:,1:end-1)))<0.0000001;
%             Compare_RMP_Mat= RMG.RMP(:,1:end-1)==repmat(RMG.RMP(:,end),1,size(RMG.RMP,2)-1);
            Compare_RMP_Mat= abs((repmat(RMG.RMP(:,end),1,size(RMG.RMP,2)-1))-(RMG.RMP(:,1:end-1)))<0.0000001;
            duplicated_Column_index=find(all(Compare_RM_Mat) & all(Compare_RMR_Mat) & all(Compare_RMP_Mat));
            if numel(duplicated_Column_index)==0            %if it was not repeated
                Next_State=size(RMG.RM,2);                     %Accept recently added state as next state      
            else                                            %else
                Next_State=duplicated_Column_index;             %remove recently added state and consider the old copy as next state
                RMG.RM(:,end)=[];
                RMG.RMR(:,end)=[];
                RMG.RMP(:,end)=[];
                end_flag=1;
            end
%             fired=PN_model.RMG.Last_fired_Tr;
            RMG.A(Previous_State,Next_State)=fired;                          %Add firing Tr as a link from previous to next state into the adjacency matrix RMG.A 
            if PN_model.Tr_Type(fired)==2
                RMG.R(Previous_State,Next_State)=PN_model.Rate(fired);           %Add firing rate of Tr as a link from previous to next state into the adjacency matrix RMG.R
            elseif PN_model.Tr_Type(fired)==3
                RMG.R(Previous_State,Next_State)=1/PN_model.Rate(fired);           %Add Mean value of firing rate of Tr as a link from previous to next state into the adjacency matrix RMG.R
            elseif PN_model.Tr_Type(fired)==4
                RMG.R(Previous_State,Next_State)=2/(PN_model.Rate(fired)+PN_model.Rate2(fired));           %Add Mean value of firing rate of Tr as a link from previous to next state into the adjacency matrix RMG.R			
            elseif PN_model.Tr_Type(fired)==0
                RMG.R(Previous_State,Next_State)=PN_model.ProbWeight(fired);     %Add firing Probability Weight of Tr as a link from previous to next state into the adjacency matrix RMG.R
            elseif (PN_model.Tr_Type(fired)==1)			%Timed
                printf('Error in Tr_Type of transition ''%s'' which is 1:Timed. \nOnly 0:Immediat or 2:Stochastic is allowed',PN_model.T(fired));
                RMG.R(Previous_State,Next_State)=0;     
            end
            Previous_State=Next_State;
            
            %make RMG.A a symmetric matrix.
            xx=size(RMG.A,1);
            yy=size(RMG.A,2);
            mm=max(xx,yy);
            if xx~=yy
                RMG.A(mm,mm)=0;
                RMG.R(mm,mm)=0;  
            end
        end
        
    else 
        printf('Error!:number of state exceeded 10000');
        end_flag=1;
    end
