function [PN_model,Run_Time,Simulation_Time]=Simulate_Fast_version(PN_model, Report_File)
global Event_Counter; 
Event_Counter=0;

% if numel(PN_model.Transition_Report_List)==0
% %     PN_model.Transition_Report_List=1:numel(PN_model.T);
% end

tic;
PN_model=Init_Counters(PN_model);
%Call simulation function
[PN_model,Key_Time,Seq,Comment,Marking_Seq] = Play_STPN_ver4(PN_model,0); 
Simulation_Time=toc;

%find maximum length of transition name
maxlen=0;
% if size(Comment,2)>0
    for i=1:numel(Comment(:,2))
        len=numel(Comment{i,2});
        if maxlen<len
            maxlen=len;
        end
    end

    % Transpose Seq 
    Seq=[1:size(Seq,2);Seq];
    Seq_temp=Seq';
    % Seq_temp=sortrows(Seq_temp,[2]);
    Seq=Seq_temp';

    %Now seq is an array of 4 value: [Event_Number, Time_tick, Transition, Token ID, Delay] 

    fid=fopen(Report_File,'wt');

    fprintf(fid,'\n-------------------------------------------------------------------------------------------------\n');
    fprintf(fid,'Event#  Enabling_Time     Delay    Firing_Time    Firing_Tr   Token_ID     Marking(befor firing)  \n');
    fprintf(fid,'-----------------------------------------------------------------------------------------------------');
    for i=1:size(Seq,2)
        fprintf(fid,'\n%6d ',Seq(1,i));
        fprintf(fid,'%12.6f  %12.6f   %12.6f   ',Seq(2,i),Seq(5,i),Seq(2,i)+Seq(5,i));
        fprintf(fid,'%s   ',[Comment{i,2},ones(1,maxlen-numel(Comment{i,2}))*' ']);     
        fprintf(fid,'%7d     ',Seq(4,i));
    %     fprintf(fid,'%d',Marking_Seq(:,i));
        for j=1:size(Marking_Seq,1)
            if Marking_Seq(j,i)<10
                fprintf(fid,'%d',Marking_Seq(j,i));
            else
                fprintf(fid,'(%d)',Marking_Seq(j,i));
            end
        end
    end
    fprintf(fid,'\n');
    fprintf(fid,'\nRunTime=%12.6f time unit    Sim_Time=%10.6f sec\n', Seq(2,end)+Seq(5,end), Simulation_Time);
    fclose(fid);
    Run_Time=Seq(2,end)+Seq(5,end);
% end
