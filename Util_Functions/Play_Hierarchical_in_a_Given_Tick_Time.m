function [PN_model,Seq,Comment,Marking_Seq,Transaction_ID_ret,deadlock,num_of_skip_tick] = Play_Hierarchical_in_a_Given_Tick_Time(PN_model,tick,Seq,Comment,Marking_Seq,Father_Name)
global Event_Counter;
global Max_Sim_Step;

Transaction_ID_ret=[];

%PN Player Main Cycle
c=0;
last_fired_Tr=[];
% deadlock=0;
num_of_skip_tick=[];
[PN_model,Firing_List,deadlock,num_of_skip_tick]=Find_Enabled_Transition_Hierarchical(PN_model,num_of_skip_tick);
while any(Firing_List) && ~deadlock
    

    if (any(Firing_List))
        %random selection of transition which fires and fire it 
        en_Tr=find(Firing_List);
%         [m,s]=sort(rand(size(en_Tr))+PN_model.Priority(en_Tr));
        
        Transaction_ID=[];
        ptr=1;
        while (numel(Transaction_ID))==0 && numel(en_Tr)>0
%             ptr=ceil(rand(1)*numel(en_Tr));
            high_Priority_Tr_logic=(PN_model.Priority(en_Tr)==min(PN_model.Priority(en_Tr)));
            high_Priority_Tr=en_Tr(find(high_Priority_Tr_logic));
            ptr=Weighted_Random(PN_model.ProbWeight(high_Priority_Tr));
            fir=high_Priority_Tr(ptr);
            
            if numel(PN_model.low_level_model(fir).T)>0     %if fir has includes a low level PN model 
                PN_model=copy_marking_down_PN(PN_model,fir);
%                 fprintf('\n\ncopy_down');
%                 print_marking(PN_model);
                [PN_model.low_level_model(fir),Seq,Comment,Marking_Seq,Transaction_ID,deadlock] = Play_Hierarchical_in_a_Given_Tick_Time(PN_model.low_level_model(fir),tick,Seq,Comment,Marking_Seq,[Father_Name,'-->',PN_model.T{fir}]); 
%                 fprintf('\n\nPlay low level');
%                 print_marking(PN_model);
                PN_model=copy_marking_up_PN(PN_model,fir);
%                 fprintf('\n\ncopy_up');
%                 print_marking(PN_model);
%                 marking=Number_of_Tokens_in_Places(PN_model,1:8);
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
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                Cur_Marking=Number_of_Tokens_in_Places(PN_model,1:numel(PN_model.P)); 
                Marking_Seq=[Marking_Seq,Cur_Marking'];         %Add marking to Marking_Seq
                
                ffun_hndl=str2func(PN_model.Firing_func{fir});                 
                [PN_model,Transaction_ID]=ffun_hndl(PN_model,fir);    
                Event_Counter=Event_Counter+1;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if numel(Transaction_ID)>0 
                    if any(PN_model.Transition_Report_List==fir)
%                         fprintf('%-20s     %-40s         %-10d       %-10d\n',PN_model.Name,PN_model.T{fir},Transaction_ID,tick);
                        c=0;
                        %Save fired squence in Seq
%                         Seq(1,size(Seq,2)+1)=tick;
                        Seq(1,size(Seq,2)+1)=tick-PN_model.Delay(fir);     %Firing time(tick number)
                        Seq(2,size(Seq,2))=fir;                            %Transition 
                        Seq(3,size(Seq,2))=Transaction_ID;                 %Tocken/Transaction ID
                        Seq(4,size(Seq,2))=PN_model.Delay(fir);            %Transition delay
%                         temp={};
%                         temp=[temp;Father_Name];
% %                         temp=[temp;Father_Name];
                        Comment=[Comment;[{[Father_Name,PN_model.Comment{fir}]},PN_model.T(fir)]];
                    end
                    %set counter of fired transition - single server semantics
                    if (PN_model.Tr_Type(fir)==1)				%timed
                        PN_model.CountT(fir)=PN_model.Delay(fir);
                    elseif (PN_model.Tr_Type(fir)==2)			%stochastic
%                         PN_model.CountT(fir)=ceil(rand(1)*PN_model.Delay(fir));
                        PN_model.Delay(fir)=exprnd(1/PN_model.Rate(fir));   %after each firing Delay is reinitialized
                        PN_model.CountT(fir)=PN_model.Delay(fir);
                     elseif (PN_model.Tr_Type(fir)==3)			%stochastic
                        PN_model.Delay(fir)=normrnd(PN_model.Rate(fir),PN_model.Rate2(fir));   %after each firing Delay is reinitialized
                        PN_model.CountT(fir)=PN_model.Delay(fir);
                    elseif (PN_model.Tr_Type(fir)==4)			%stochastic
                        PN_model.Delay(fir)=unifrnd(PN_model.Rate(fir),PN_model.Rate2(fir));   %after each firing Delay is reinitialized
                        PN_model.CountT(fir)=PN_model.Delay(fir);
                   end
                end
            end
            if numel(Transaction_ID_ret)==0
                Transaction_ID_ret=Transaction_ID;
            end
            en_Tr(find(en_Tr==fir))=[]; %remove fired Transition from en_Tr 
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
    num_of_skip_tick=[];
    [PN_model,Firing_List,deadlock,num_of_skip_tick]=Find_Enabled_Transition_Hierarchical(PN_model,num_of_skip_tick);
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
    if Event_Counter>Max_Sim_Step
        deadlock=1;
%         fprintf('Error:Number of simulation step exceeded Max_Sim_Step\n');  
    end
    if deadlock==1  % the last state is being reported
       Cur_Marking=Number_of_Tokens_in_Places(PN_model,1:numel(PN_model.P)); 
       Marking_Seq=[Marking_Seq,Cur_Marking'];         %Add marking to Marking_Seq
       Seq(1,size(Seq,2)+1)=tick;     %Firing time(tick number)
       Seq(2,size(Seq,2))=0;                            %Transition 
       Seq(3,size(Seq,2))=0;                 %Tocken/Transaction ID
       Seq(4,size(Seq,2))=0;            %Transition delay
       Comment=[Comment;{'',' - '}];
    end
end %Main Cycle
