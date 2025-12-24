function [TRMG,end_flag,Previous_State]=Add_New_State_to_TRMG_Hierarchical_Model(PN_model,TRMG,Previous_State,CountT_backup)
        
        end_flag=0;
        Cur_Marking=Number_of_Tokens_in_Places(PN_model,2:numel(PN_model.P));
        TRMG.RM=[TRMG.RM,Cur_Marking'];         %Add marking to RM
        TRMG.RMD=[TRMG.RMD,CountT_backup'];     %Add delayes to RMD

        if size(TRMG.RM,2)>1
            %check for duplication
            Compare_RM_Mat= TRMG.RM(:,1:end-1)==repmat(TRMG.RM(:,end),1,size(TRMG.RM,2)-1);
            Compare_RMD_Mat= TRMG.RMD(:,1:end-1)==repmat(TRMG.RMD(:,end),1,size(TRMG.RMD,2)-1);
            duplicated_Column_index=find(all(Compare_RM_Mat) & all(Compare_RMD_Mat));
            if numel(duplicated_Column_index)==0            %if it was not repeated
                Next_State=size(TRMG.RM,2);                     %Accept recently added state as next state      
            else                                            %else
                Next_State=duplicated_Column_index;             %remove recently added state and consider the old copy as next state
                TRMG.RM(:,end)=[];
                TRMG.RMD(:,end)=[];
                end_flag=1;
            end
            fir=PN_model.TRMG.Last_fired_Tr;
            TRMG.A(Previous_State,Next_State)=fir;                          %Add firing Tr as a link from previous to next state into the adjacency matrix TRMG.A 
            TRMG.D(Previous_State,Next_State)=TRMG.RMD(fir,Previous_State); %Add time to fire of Tr as a link from previous to next state into the adjacency matrix TRMG.D
            Previous_State=Next_State;
        end


