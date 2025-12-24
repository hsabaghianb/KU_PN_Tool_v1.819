function [P]=Steady_State_solution_for_TRMG(TRMG,Q)
Q2=Q;
Q2(:,end)=1;
B=zeros(1,size(Q,2));% <----------------------------------------------------------------------------------------------------------------
B(end)=1;            %                                                                                                                  |  
P=B*inv(Q2);         %solve AX=B where the main quation is PQ=0 --> QtPt=0  then the last line of Qt (and the 0 vector) filled by 1.    |
                     %                                                           so instead the last column of Q filled by 1------------ 
% % Stationary_Mask_seq=P>0.00001; 
% % Sum_of_outgoing_rate=sum(Q.*(1-eye(size(Q))),2);
% % Average_Delay_for_States=Sum_of_outgoing_rate;
% % Average_Delay_for_States(Average_Delay_for_States>0)=1./Sum_of_outgoing_rate(Average_Delay_for_States>0);
% % 
% % Transient_Delay_Seq=Average_Delay_for_States'.*(1-Stationary_Mask_seq);
% % Stationary_Delay_Seq=Average_Delay_for_States'.*Stationary_Mask_seq;
% % Stationary_Period=sum(Stationary_Delay_Seq);
% % Transient_Period=sum(Transient_Delay_Seq);
% % Throughput=1000000000/(Stationary_Period+.0000000001);
% % Tr_Seq=[];
% % Delay_Seq=[];
% % % Tr_Seq=sum(TRMG.A,2)';                           %A vector that contains Transition number for all(transient and steady states) timed_marking
% % % Delay_Seq=sum(TRMG.D,2)';                        %A vector that contains delays for all(transient and steady states) timed_marking
% % % Stationary_Mask_seq=zeros(size(Tr_Seq));
% % % if numel(TRMG.Last_Marking_If_Deadlock)==0            %If not deadlock
% % %     Stationary_Mask_seq(find(TRMG.A(end,:)):end)=1;   %A 0,1 vector that distinguish stationary states from transient states (0:transient 1:stationary)
% % %     Transient_Delay_Seq=(P==0).*Delay_Seq;
% % %     Stationary_Delay_Seq=(P>0).*Delay_Seq;
% % %     Transient_Period=sum(Transient_Delay_Seq);
% % %     Stationary_Period=sum(Stationary_Delay_Seq);
% % %     Throughput=1000000000/(Stationary_Period+.0000000001);
% % % else
% % %     Stationary_Mask_seq(TRMG.Last_Marking_If_Deadlock)=1;   %A 0,1 vector that distinguish stationary states from transient states (0:transient 1:stationary)    
% % %     Transient_Delay_Seq=(P==0).*Delay_Seq;
% % %     Stationary_Delay_Seq=(P>0).*Delay_Seq;
% % %     Transient_Period=sum(Transient_Delay_Seq);
% % %     Stationary_Period=[];
% % %     Throughput=[];
% % % end 
% % % 
