function [Run_Time,Simulation_Time]=Simulate_PN_model(PN_model, Report_File, Max_Step)
global Max_Sim_Step;
Max_Sim_Step=Max_Step;  
global Max_Sim_Time;
Max_Sim_Time=0;
PN_model.Transition_Report_List=1:numel(PN_model.T);
[PN_model,Run_Time,Simulation_Time]=Simulate_Fast_version(PN_model, Report_File);
Display_File_in_Edit_Box(Report_File);
