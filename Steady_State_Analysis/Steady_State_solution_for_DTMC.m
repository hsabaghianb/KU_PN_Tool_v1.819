function [Pi]=Steady_State_solution_for_DTMC(P)
P=P./(repmat(sum(P,2),1,size(P,2)));
Q=P-eye(size(P));
Q2=Q';
Q2(end,:)=1;
B=zeros(size(Q2,2),1);
B(end)=1;
Pi=inv(Q2)*B;
