function [TRMG,end_flag,Previous_State]=Add_New_State_to_TRMG_ver5(PN_model,TRMG,Previous_State,fir, time2fire)
        
        end_flag=0;
        Cur_Marking=Number_of_Tokens_in_Places(PN_model,1:numel(PN_model.P)); 
        TRMG.RM=[TRMG.RM,Cur_Marking'];         %Add Place marking to RM
        TRMG.RMD=[TRMG.RMD,PN_model.CountT'];     %Add Transition delayes to RMD
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %             
               Token_Delay_backup=PN_model.M0;
               for Pl=1:numel(PN_model.P)
                   for Tk=1:numel(Token_Delay_backup{Pl})
                       Token_Delay_backup{Pl}{Tk}=Token_Delay_backup{Pl}{Tk}(4);
                   end
               end
        TRMG.RMTD=[TRMG.RMTD,{Token_Delay_backup}];     %Add Token delayes to RMTD
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %             

%   Cur_Marking
%   CountT_backup
        if size(TRMG.RM,2)>1 && numel(fir)>0
            %check for duplication
            Compare_RM_Mat= TRMG.RM(:,1:end-1)==repmat(TRMG.RM(:,end),1,size(TRMG.RM,2)-1);
            Compare_RMD_Mat= TRMG.RMD(:,1:end-1)==repmat(TRMG.RMD(:,end),1,size(TRMG.RMD,2)-1);
            duplicated_Column_index=find(all(Compare_RM_Mat) & all(Compare_RMD_Mat));
            if numel(duplicated_Column_index)==0            %if it was not repeated
                Next_State=size(TRMG.RM,2);                     %Accept recently added state as next state      
            else                                            %else        
                                                                %check for token delay similarity for duplicated_Column_index  
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
               match=[];
               for i=1:numel(duplicated_Column_index)
                   match(i)=1;
                   Pl=1;
                   while Pl<=numel(PN_model.P) && match(i)==1
                       if numel(Token_Delay_backup{Pl})==numel(TRMG.RMTD{duplicated_Column_index(i)}{Pl})
                           Tk=1;
                           while Tk<=numel(Token_Delay_backup{Pl}) && match(i)==1
                               if Token_Delay_backup{Pl}{Tk}(1)~=TRMG.RMTD{duplicated_Column_index(i)}{Pl}{Tk}(1)
                                   match(i)=0;
                               end
                               Tk=Tk+1;
                           end
                       else
                           match(i)=0;  
                       end
                       Pl=Pl+1;
                   end
               end
               duplicated_Column_index(match==0)=[];
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %                                                                             
               if numel(duplicated_Column_index)==0                                   %if token delay was not matched               
                   Next_State=size(TRMG.RM,2);                     %Accept recently added state as next state      
               else                                          %else token delay is matched
                    Next_State=duplicated_Column_index;            %remove recently added state and consider the old copy as next state
                    TRMG.RM(:,end)=[];
                    TRMG.RMD(:,end)=[];
                    TRMG.RMTD(end)=[];
                    end_flag=1;
               end
            end
            TRMG.A(Previous_State,Next_State)=fir;                          %Add firing Tr as a link from previous to next state into the adjacency matrix TRMG.A 
            TRMG.D(Previous_State,Next_State)=time2fire;
            TRMG.Pr(Previous_State,Next_State)=PN_model.ProbWeight(fir);
            Previous_State=Next_State;
            
            xx=size(TRMG.A,1);
            yy=size(TRMG.A,2);
            mm=max(xx,yy);
            if xx~=yy
                TRMG.A(mm,mm)=0;
                TRMG.D(mm,mm)=0;  
            end

        end
