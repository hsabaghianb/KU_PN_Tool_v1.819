function t=null_model_PN(Name)
t.Name=Name;            %Model name 
t.P=[];                 %Places list
t.T=[];                 %Transitions list
t.PPre=[];              %Partial Precondition
t.InhPPre=[];           %List of Pre Places which connected to each transition as Inhibitors 
t.PPost=[];             %Partial Postcondition 
t.Prd=[];               %Producers of each transition
t.Cns=[];               %Consumer transitions of each place
t.InhCns=[];            %Inhibitor Consumer transitions of each place
t.M0=[];                %Marking
t.Cap=[];               %Capacitance of each place
t.Firing_func=[];       %Firing function name (string)
t.Pre_Weight=[];        %Precondition arc weight
t.InhPre_Weight=[];     %Precondition Inhibitor arc weight
t.Post_Weight=[];       %Postcondition arc weight
t.Delay=[];             %Delay of each transition (if type of transition is 1:Timed)
t.Rate=[];              %Firing rate of each transition   (if type of transition is 2:Stochastic)
t.ProbWeight=[];        %Probability Weight of each transition 
t.TknDly=[];            %For each transition TknDly is added to output tokens 
t.Priority=[];          %Priority number of transitions
t.Tr_Type=[];           %0:Immediate 1:Timed  2:Stochastic 
t.Pl_Type=[];           %0:Control 1:Data
t.CountT=[];            %Time counter of each Transition
t.low_level_model=[];   %Corresponding low level model for each transition(it is a cell array)
t.Tr_State=[];          %this field is added for fast simulation      bit3 bit2 bit1 bit0      bit0:marking OK      
                        %0:marking condition not satisfied             0    0    0    0        bit1:Token_delay=0        
                        %1:Marking OK and token_delay>0 and count>0                            bit2:Tr_delay=0
                        %3:Marking OK and token_delay=0 and count>0                            bit3:Unchecked   
                        %5:Marking OK and token_delay>0 and count=0 
                        %7:Marking OK and token_delay=0 and count=0  fully enabled




t.RMG.A=[];    %Adjacency Matrix
t.RMG.R=[];    %Rate
t.RMG.RM=[];   %Reachale Marking
t.RMG.RMR=[];  %Reachale Marking Rate (Rate of transitions for stochastic)
t.RMG.RMP=[];  %Reachale Marking Proaility (proaility weight of transitions for Immediate)
t.RMG.EnTr=[]; %Enabled Transitions for each state
t.RMG.VS=[];   %Vanishing States

t.TRMG.A=[];   %Adjacency Matrix
t.TRMG.D=[];   %Delay Matrix
t.TRMG.Pr=[];  %Probability
t.TRMG.RM=[];  %Reachable Marking
t.TRMG.RMD=[]; %Reachable Marking Delay (Delay of transitions for Timed transition)
t.TRMG.RMTD=[];%Reachable Marking Token Delay 
t.TRMG.VS=[];   %Vanishing States
t.TRMG.StPtr=1;
t.TRMG.Last_fired_Tr=[];
t.TRMG.Last_Marking_If_Deadlock=[];
t.TRMG.Conflict_Accurate_Cummulative_Delay=0;


t.Request_exclusion=[];         %A variable that play the role of Request_exclusion control place(in the higher level PN modeling) 
t.Response_exclusion=[];        %A variable that play the role of Responce_exclusion control place(in the higher level PN modeling)
t.Target_mode=[];               %Specifies the mode if this model is a Target
t.Initiator_mode=[];            %Specifies the mode if this model is a Initiator
t.Transition_Report_List=[];    
t.Enabled_Tr=[];                
t.PI_Places=[];                 %All input Places of a PN model
t.InhPI_Places=[];              %All inhibitor input Places of a PN model
t.PO_Places=[];                 %All output Places of a PN model 
t.address=[];                   %specifies the address of each transition
t.Comment=[];                   %specifies a Comment of each transition



t.start_Tr=[];
t.end_Tr=[];

t.request_exclusion_place=[];
t.response_exclusion_place=[];

t.Eff_Pl=[];                %Effective places which is useful for optimization
t.Eff_Tr=[];                %Effective Transitions which is useful for optimization

t.temp_tick=0;
t.previous_firing_tick=0;
t.SelfService=[];

t.Firing_Seq=[];