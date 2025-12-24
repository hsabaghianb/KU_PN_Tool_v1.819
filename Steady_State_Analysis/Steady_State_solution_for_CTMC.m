function [P]=Steady_State_solution_for_CTMC(Q)
% Q2=Q;
% Q2(:,end)=1;
% B=zeros(1,size(Q,2));
% B(end)=1;
% P=B*inv(Q2);
% 

Q2=Q';
Q2(end,:)=1;
B=sparse(size(Q,2),1);
B(end)=1;
P=(Q2\B)';
