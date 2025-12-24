function Main_Performance_Evaluation_for_TPN()
PN_model=Example5();
Draw_PN_Model(PN_model);
%Analytical solution
[PN_model,TRMG] = Reachable_Marking_Graph_of_Timed_PN_ver2(PN_model,0);
Draw_TRMG(TRMG);
Q=Generation_Matrix_for_TRMG(TRMG);
[P,Throughput,Transient_Period,Permanent_Cycle_Time,Tr_Seq,Delay_Seq,Stationary_Mask_seq]=Steady_State_solution_for_TRMG(TRMG,Q);
    