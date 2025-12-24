function P=Main_Performance_Evaluation_for_SPN()
PN_model=Example10();
% PN_model=University_Education();


Draw_PN_Model(PN_model);
%Analytical solution

% Initialize Reachable Marking Graph(RMG)
RMG.A=[];    %Adjacency Matrix
RMG.R=[];    %Rate
RMG.RM=[];   %Reachale Marking
Previous_State=1;
first_firing_tr=[];
RMG = Reachable_Marking_Graph_of_SPN_ver2(PN_model,RMG,Previous_State, first_firing_tr);
Draw_RMG(RMG);
if ~all(all(RMG.R==0))
    Draw_DTMC_CTMC(RMG); 
end

% Q=Generation_Matrix_for_CTMC(RMG);
% [P]=Steady_State_solution_for_CTMC(Q);
[P]=Steady_State_solution_for_DTMC(RMG.R);

    