function [PN_model,Key_Time,Seq,Comment,Marking_Seq] = Play_STPN_ver4(PN_model,tick)
% Support timed transition  YES
% Support timed token       YES
% Hierarchical simulator    YES
% Supports inhibitor arcs   YES

global Time_Skip_Counter;
global Event_Counter;
global Max_Sim_Step;
global Max_Sim_Time;

Seq=[];
Comment=[];
Marking_Seq=[];


nopl=numel(PN_model.P);
Key_Time=[];
% error=0;
% if any(PN_model.Delay & ~PN_model.Tr_Type) 
% 	find(xor(PN_model.Delay,PN_model.Tr_Type));
% 	sprintf('!!!! Transition PN_model.Tr_Type and PN_model.Delay do not coincide')
% 	error=1;
% end
% if all(PN_model.Delay==0) 
% 	sprintf('!!!! There is no timed transition - program can infinitelly run')
% 	error=2;
% end 

% if (error==0)
% PN_model=Init_Counters(PN_model);
deadlock=0;
PN_model.Tr_State=ones(1,numel(PN_model.T))*8; %mark all transition to unchecked state
while ~deadlock && (size(Seq,2)<=Max_Sim_Step)
%     '((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((('
%     Report_Exclusion_States(PN_model,'',[]);
%     ')))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))'
% size(Seq,2)
    [PN_model,Seq,Comment,Marking_Seq,Transaction_ID,deadlock] = Play_Hierarchical_in_a_Given_Tick_Time_Fast(PN_model,tick,Seq,Comment,Marking_Seq,'');
%     fprintf('\n\n');
%      print_marking(PN_model);
    [PN_model,num_of_skip_tick]=Time_to_Next_Event(PN_model);
    if numel(num_of_skip_tick)==0
        num_of_skip_tick=0;
    end
    if Max_Sim_Time>0
        if tick >= Max_Sim_Time
            deadlock=1;
        end
    end

    if ~deadlock
        [PN_model,tick]=Improve_Tick_Time(PN_model,tick,num_of_skip_tick);
        Time_Skip_Counter=Time_Skip_Counter+1;
    end
%     fprintf('\nTime_Skip=%-6d  tick=%-6d  Event=%-6d',Time_Skip_Counter,tick, Event_Counter);
end
% if (size(Seq,2)>Max_Sim_Step)
% %    fprintf('Error:Number of simulation step exceeded Max_Sim_Step'); 
%    deadlock=1;
% end
%     
    
    

%     if c>100
%     fprintf('Error');
%     end

end 