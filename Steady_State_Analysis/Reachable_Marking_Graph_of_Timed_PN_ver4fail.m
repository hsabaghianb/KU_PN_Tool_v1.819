%This function has been written but not completed and not worked correctly 
function [PN_model,TRMG] = Reachable_Marking_Graph_of_Timed_PN_ver4fail(PN_model,Initial_Delay)
% function [PN_model,TRMG] = Reachable_Marking_Graph_of_Timed_PN_ver2(PN_model,Initial_Delay)

% Support timed transition  YES
% Support timed token       YES
% Hierarchical simulator    YES
% Supports inhibitor arcs   YES

tick=Initial_Delay;
Comment=[];


nopl=numel(PN_model.P);
Key_Time=[];

PN_model=Init_Counters(PN_model);
CountT_backup=PN_model.CountT;
% PN_model.RTMG.Last_fired_Tr=[];

deadlock=0;
Last_fired_Tr=[];
while ~deadlock
    [PN_model,PN_model.TRMG.RM,Comment,Transaction_ID,deadlock,num_of_skip_tick,CountT_backup,Last_fired_Tr] = Play_Hierarchical_for_RTMG_Extraction_in_a_Given_Tick_Time(PN_model,tick,CountT_backup,PN_model.TRMG.RM,Comment,' ',Last_fired_Tr);

    fprintf('%d\n',size(PN_model.TRMG.RM,2));
    if numel(num_of_skip_tick)==0
        num_of_skip_tick=1;
    end
%     num_of_skip_tick
    [PN_model,tick]=Improve_Tick_Time(PN_model,tick,num_of_skip_tick);
end
% 'done'
    
%   if size(PN_model.TRMG.A,1)<size(PN_model.TRMG.A,2)
%       c=size(PN_model.TRMG.A,2)
%       PN_model.TRMG.A(c,c)=0;             
%       PN_model.TRMG.D(c,c)=0;            
%   end
    


