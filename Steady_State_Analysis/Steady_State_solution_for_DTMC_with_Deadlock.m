function [Pi]=Steady_State_solution_for_DTMC_with_Deadlock(P)
    Pi=zeros(1,size(P,2));
%     InitState=input('Please Input the Initial State:');
%     Pi(1,InitState)=1;                   %initial state
    Pi(1,1)=1;                   %initial state
    next_Pi=Pi*P;                %next step probability vector
    while sum(abs(next_Pi-Pi))>0.00001
       Pi=next_Pi;
       next_Pi=Pi*P;
    end
    Pi=next_Pi;
end