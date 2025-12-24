%This function has been written but not completed and not worked correctly 
function [PN_model,Seq,Comment,Transaction_ID_ret,deadlock,num_of_skip_tick,CountT_backup,Last_fired_Tr] = Play_Hierarchical_for_RTMG_Extraction_in_a_Given_Tick_Time(PN_model,tick,CountT_backup,Seq,Comment,Father_Name,Last_fired_Tr)
Transaction_ID_ret=[];

%------------------------------------  added for RTMG extraction
first_time_after_firing=0;
end_flag=0;
%-------------------------------------

    
%PN Player Main Cycle
c=0;
last_fired_Tr=[];
% deadlock=0;
num_of_skip_tick=[];
% [PN_model,Firing_List,deadlock,num_of_skip_tick]=Find_Enabled_Transition_Hierarchical(PN_model,num_of_skip_tick);
[PN_model,Firing_List,deadlock,num_of_skip_tick]=Find_Enabled_Transition_with_Inhibitor_Hierarchical(PN_model,num_of_skip_tick);
while any(Firing_List)  && ~end_flag 
    %------------------------------------  added for RTMG extraction
%      if first_time_after_firing
%          CountT_backup=PN_model.CountT;
%          first_time_after_firing=0;
%      end
    %-------------------------------------

    if (any(Firing_List))
        %random selection of transition which fires and fire it 
        en_Tr=find(Firing_List>0);
%         [m,s]=sort(rand(size(en_Tr))+PN_model.Priority(en_Tr));
        
        Transaction_ID=[];
        ptr=1;
        while (numel(Transaction_ID))==0 && ptr<=numel(en_Tr)  %if there was non-empty en_Tr, thay will checked one by one, will fire if countT is zero, 
                                                               % and exit the while loop if en_Tr finished or just one Tr is fired
            fir=en_Tr(ptr);
            if numel(PN_model.low_level_model(fir).T)>0
                PN_model=copy_marking_down_PN(PN_model,fir);
%                 fprintf('\n\ncopy_down');
%                 print_marking(PN_model);

                CountT_backup=PN_model.low_level_model(fir).CountT;
                [PN_model.low_level_model(fir),Seq,Comment,Transaction_ID,deadlock,num_of_skip_tick,CountT_backup] = Play_Hierarchical_for_RTMG_Extraction_in_a_Given_Tick_Time(PN_model.low_level_model(fir),tick,CountT_backup,Seq,Comment,[Father_Name,'-->',PN_model.T{fir}]); 
%                 fprintf('\n\nPlay low level');
%                 print_marking(PN_model);
                PN_model=copy_marking_up_PN(PN_model,fir);
%                 fprintf('\n\ncopy_up');
%                 print_marking(PN_model);
                marking=Number_of_Tokens_in_Places(PN_model,1:8);
%                 if ~all(marking==0)
%                     fprintf('\n');
%                     place_with_token=find(marking);
%                     fprintf('Place %s : ',PN_model.P{place_with_token});
%                     if mod(place_with_token,2)==1     
%                         fprintf('Null, ');
%                     elseif PN_model.M0{place_with_token}{1}(3)==0
%                         fprintf('TLM_ACCEPTED, ');
%                     elseif PN_model.M0{place_with_token}{1}(3)==2
%                         fprintf('TLM_UPDATED, ');
%                     elseif PN_model.M0{place_with_token}{1}(3)==1
%                         fprintf('TLM_COMPLETED, ');
%                     end
%                     fprintf('%s',State_Name(PN_model.M0{place_with_token}{1}(5)));
%                 end
            else
                [PN_model.TRMG,end_flag,PN_model.TRMG.StPtr]=Add_New_State_to_TRMG(PN_model,PN_model.TRMG,PN_model.TRMG.StPtr,CountT_backup);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                ffun_hndl=str2func(PN_model.Firing_func{fir});                 
                [PN_model,Transaction_ID]=ffun_hndl(PN_model,fir);    
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %------------------------------------  added for RTMG extraction
                first_time_after_firing=1;
                %-------------------------------------
                if numel(Transaction_ID)>0 
                    if any(PN_model.Transition_Report_List==fir)
%                         fprintf('%-20s     %-40s         %-10d       %-10d\n',PN_model.Name,PN_model.T{fir},Transaction_ID,tick);
                        c=0;
                        %Save fired squence in Seq
%                         Seq(1,size(Seq,2)+1)=tick;
                        Seq(1,size(Seq,2)+1)=tick-PN_model.Delay(fir);
                        Seq(2,size(Seq,2))=fir;
                        Seq(3,size(Seq,2))=Transaction_ID;
                        Seq(4,size(Seq,2))=PN_model.Delay(fir);
                        temp={};
                        temp=[temp;Father_Name];
%                         temp=[temp;Father_Name];
                        Comment=[Comment;[temp(1),PN_model.T(fir)]];
                    end
%                     end_flag=end_flag
%                     PN_model.CountT
                    %set counter of fired transition - single server semantics
                    if (PN_model.Tr_Type(fir)==1)				%timed
                        PN_model.CountT(fir)=PN_model.Delay(fir);
                    elseif (PN_model.Tr_Type(fir)==2)			%stochastic
                        PN_model.CountT(fir)=ceil(rand(1)*PN_model.Delay(fir));
                    end
%                     PN_model.CountT
                    
                    %------------------------------------  added for RTMG extraction
                    CountT_backup=PN_model.CountT; 
                    PN_model.TRMG.Last_fired_Tr=fir;
                    %-------------------------------------
                end
            end
            if numel(Transaction_ID_ret)==0
                Transaction_ID_ret=Transaction_ID;
            end
            ptr=ptr+1;
        end
        if numel(Transaction_ID)==0 && ptr>numel(en_Tr)
            last_fired_Tr=sort(en_Tr);
        end
% 		PN_model.M0(PN_model.PPre{fir})=PN_model.M0(PN_model.PPre{fir})+1;
% 		PN_model.M0(PN_model.PPost{fir})=PN_model.M0(PN_model.PPost{fir})+1;
        c=c+1;
    end
    if c>100
        deadlock=1;
    end
%     [PN_model,Firing_List,deadlock,num_of_skip_tick]=Find_Enabled_Transition_Hierarchical(PN_model,num_of_skip_tick);
    [PN_model,Firing_List,deadlock,num_of_skip_tick]=Find_Enabled_Transition_with_Inhibitor_Hierarchical(PN_model,num_of_skip_tick);
    % 	find(Firing_List)
    if (any(Firing_List)) 
        en_Tr=find(Firing_List>0);
%         if numel(en_Tr)==1
            if numel(en_Tr)==numel(last_fired_Tr)
                if all(last_fired_Tr==sort(en_Tr))
                    Firing_List=Firing_List*0;
%                     deadlock=1;
                end
            end
%         end
    end
if end_flag
    deadlock=1;
end

end %Main Cycle

