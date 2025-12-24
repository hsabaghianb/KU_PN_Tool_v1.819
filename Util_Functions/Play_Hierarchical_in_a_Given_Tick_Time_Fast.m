function [PN_model,Seq,Comment,Marking_Seq,Transaction_ID_ret,deadlock] = Play_Hierarchical_in_a_Given_Tick_Time_Fast(PN_model,tick,Seq,Comment,Marking_Seq,Father_Name)
global Event_Counter;
global Max_Sim_Step;

Transaction_ID_ret=[];

%PN Player Main Cycle
c=0;
last_fired_Tr=[];
% deadlock=0;
num_of_skip_tick=[];
[PN_model,Firing_List,deadlock]=Find_Enabled_Transition_Hierarchical_Fast(PN_model);
while any(Firing_List) && ~deadlock
    if (any(Firing_List))
        %random selection of transition which fires and fire it 
        en_Tr=find(Firing_List);     
        Transaction_ID=[];
        ptr=1;
      
        while (numel(Transaction_ID))==0 && numel(en_Tr)>0
            high_Priority_Tr_logic=(PN_model.Priority(en_Tr)==min(PN_model.Priority(en_Tr)));
            high_Priority_Tr=en_Tr(high_Priority_Tr_logic);
            ptr=Weighted_Random(PN_model.ProbWeight(high_Priority_Tr));
            fir=high_Priority_Tr(ptr);
            
            if numel(PN_model.low_level_model(fir).T)>0     %if fir has includes a low level PN model 
                PN_model=copy_marking_down_PN(PN_model,fir);
                [PN_model.low_level_model(fir),Seq,Comment,Marking_Seq,Transaction_ID,deadlock] = Play_Hierarchical_in_a_Given_Tick_Time_Fast(PN_model.low_level_model(fir),tick,Seq,Comment,Marking_Seq,[Father_Name,'-->',PN_model.T{fir}]); 
                PN_model=copy_marking_up_PN(PN_model,fir);
            else
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                Cur_Marking=Number_of_Tokens_in_Places(PN_model,1:numel(PN_model.P)); 
%                 Marking_Seq=[Marking_Seq,Cur_Marking'];         %Add marking to Marking_Seq
                
                ffun_hndl=str2func(PN_model.Firing_func{fir});
               
                [PN_model,Transaction_ID]=ffun_hndl(PN_model,fir);    
                PN_model.Firing_Seq=[PN_model.Firing_Seq,fir];
                Event_Counter=Event_Counter+1;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if numel(Transaction_ID)>0 
                    if any(PN_model.Transition_Report_List==fir)
%                         fprintf('%-20s     %-40s         %-10d       %-10d\n',PN_model.Name,PN_model.T{fir},Transaction_ID,tick);
                        %Save fired squence in Seq
%                         Seq(1,size(Seq,2)+1)=tick;
                        Marking_Seq=[Marking_Seq,Cur_Marking'];         %Add marking to Marking_Seq
                        Seq(1,size(Seq,2)+1)=tick-PN_model.Delay(fir);     %Firing time(tick number)
                        Seq(2,size(Seq,2))=fir;                            %Transition 
                        Seq(3,size(Seq,2))=Transaction_ID;                 %Tocken/Transaction ID
                        Seq(4,size(Seq,2))=PN_model.Delay(fir);            %Transition delay
                        Comment=[Comment;[{[Father_Name,PN_model.Comment{fir}]},PN_model.T(fir)]];
                    end
%                     c=0;                    
                    %set counter of fired transition - single server semantics
                    if (PN_model.Tr_Type(fir)==1)				%timed
                        PN_model.CountT(fir)=PN_model.Delay(fir);
                    elseif (PN_model.Tr_Type(fir)==2)			%stochastic
                        PN_model.Delay(fir)=exprnd(1/PN_model.Rate(fir));   %after each firing Delay is reinitialized
                        PN_model.CountT(fir)=PN_model.Delay(fir);
                     elseif (PN_model.Tr_Type(fir)==3)			%stochastic
                        PN_model.Delay(fir)=abs(normrnd(PN_model.Rate(fir),PN_model.Rate2(fir)));   %after each firing Delay is reinitialized
                        PN_model.CountT(fir)=PN_model.Delay(fir);
                    elseif (PN_model.Tr_Type(fir)==4)			%stochastic
                        PN_model.Delay(fir)=abs(unifrnd(PN_model.Rate(fir),PN_model.Rate2(fir)));   %after each firing Delay is reinitialized
                        PN_model.CountT(fir)=PN_model.Delay(fir);%                     elseif (PN_model.Tr_Type(fir)==3)			%Norrmal

%                         PN_model.Delay(fir)=normrnd(PN_model.Mean(fir), PN_model.Std(fir));   %after each firing Delay is reinitialized
%                         PN_model.CountT(fir)=PN_model.Delay(fir);
%                     elseif (PN_model.Tr_Type(fir)==4)			%Uniform
%                         PN_model.Delay(fir)=unifrnd(PN_model.UnifA(fir),PN_model.Unifb(fir));   %after each firing Delay is reinitialized
%                         PN_model.CountT(fir)=PN_model.Delay(fir);

                    end
                end
            end
            if numel(Transaction_ID_ret)==0
                Transaction_ID_ret=Transaction_ID;
            end
            en_Tr(en_Tr==fir)=[]; %remove fired Transition from en_Tr 
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            PN_model=Mark_Tr_and_Its_Neighbors_as_Unchecked(PN_model,fir);   %%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
            
        end
        if numel(Transaction_ID)==0 && ptr>numel(en_Tr)
            last_fired_Tr=sort(en_Tr);
        end
%         c=c+1;
    end
%     if c>100
%         deadlock=1;
%     end
% 
    [PN_model,Firing_List,deadlock]=Find_Enabled_Transition_Hierarchical_Fast(PN_model);
    % 	find(Firing_List)
    if (any(Firing_List)) 
        en_Tr=find(Firing_List>0);
            if numel(en_Tr)==numel(last_fired_Tr)
                if all(last_fired_Tr==sort(en_Tr))
                    Firing_List=Firing_List*0;
                end
            end
    end
    if Event_Counter >= Max_Sim_Step
        deadlock=1;
%         fprintf('Error:Number of simulation step exceeded Max_Sim_Step\n');  
    end
    if deadlock==1                                      % the last state is being reported
       Cur_Marking=Number_of_Tokens_in_Places(PN_model,1:numel(PN_model.P)); 
       Marking_Seq=[Marking_Seq,Cur_Marking'];          %Add marking to Marking_Seq
       Seq(1,size(Seq,2)+1)=tick;                       %Firing time(tick number)
       Seq(2,size(Seq,2))=0;                            %Transition 
       Seq(3,size(Seq,2))=0;                            %Tocken/Transaction ID
       Seq(4,size(Seq,2))=0;                            %Transition delay
       Comment=[Comment;{'',' - '}];
    end
end %Main Cycle


