function [PN_model,Tr_num]=New_Transition(PN_model,Name,Firing_func_name,Type,TrValue,TknDly,Priority,Probability)
%---------------------------------------------------------------
%[PN_model,Tr_num]=New_Transition(PN_model, Name, Firing_func_name, Type=0/1/2, TrValue=0/TrDly/Rate, TknDly, Priority, Probability)
%Type=0:Immediate 1:Timed 2:Stochastic 
%---------------------------------------------------------------

Tr_num=numel(PN_model.T)+1;
t=null_model_PN(Name);
% t=Init_PN(Name);
if Tr_num==1
    PN_model.low_level_model=t;    
else
    PN_model.low_level_model(Tr_num)=t;
end

PN_model.T=[PN_model.T;{Name}];
PN_model.Firing_func=[PN_model.Firing_func; {Firing_func_name}];                  
PN_model.Tr_Type=[PN_model.Tr_Type,Type];

if Type==0  %Immediate
    if (numel(TrValue)>1)% distribution function for token delay
        if TrValue(1)==2 %Stochastic exponential
            PN_model.Rate=[PN_model.Rate,TrValue(2)];
            PN_model.Delay=[PN_model.Delay,0];
        elseif TrValue(1)==3 %Stochastic Normal Random
            PN_model.Rate=[PN_model.Rate,TrValue(2)];
            PN_model.Rate2(numel(PN_model.Rate))=TrValue(3);
            PN_model.Delay=[PN_model.Delay,0];
        elseif TrValue(1)==4 %Stochastic Uniform Random
            PN_model.Rate=[PN_model.Rate,TrValue(2)];
            PN_model.Rate2(numel(PN_model.Rate))=TrValue(3);
            PN_model.Delay=[PN_model.Delay,0]; 
        end
    else
        PN_model.Delay=[PN_model.Delay,0];
        PN_model.Rate=[PN_model.Rate,0];
    end
elseif Type==1 %Timed
    PN_model.Delay=[PN_model.Delay,TrValue];
    PN_model.Rate=[PN_model.Rate,0];
elseif Type==2 %Stochastic exponential
    PN_model.Rate=[PN_model.Rate,TrValue];
    PN_model.Delay=[PN_model.Delay,exprnd(1/TrValue)];
elseif Type==3 %Stochastic Normal Random
    PN_model.Rate=[PN_model.Rate,TrValue(1)];
    PN_model.Rate2(numel(PN_model.Rate))=TrValue(2);
    PN_model.Delay=[PN_model.Delay,abs(normrnd(TrValue(1),TrValue(2)))];
elseif Type==4 %Stochastic Uniform Random
    PN_model.Rate=[PN_model.Rate,TrValue(1)];
    PN_model.Rate2(numel(PN_model.Rate))=TrValue(2);
    PN_model.Delay=[PN_model.Delay,abs(unifrnd(TrValue(1),TrValue(2)))];
elseif Type==12  %BPMN Component XOR Gateway
    PN_model.Delay=[PN_model.Delay,TrValue];
    PN_model.Rate=[PN_model.Rate,0];
elseif Type==13  %BPMN Component Decision Gateway
    PN_model.Delay=[PN_model.Delay,TrValue];
    PN_model.Rate=[PN_model.Rate,0];
    
%     -----------------------------------------------------------------------------
%     Note: Delay is not matter for Stochastic_Timed SelfService and Stochastic_Timed 
%     ParallelMultiServer transitions, except for constant time. the tr will be converted 
%     in function 'Convert_BPMN_to_PN_Model' and delay will be reloaded.
%     but it is set by a arbitrary value due to completeness the delay array
%     -----------------------------------------------------------------------------
elseif Type==20  %BPMN Component Task_Timed_SelfService 
    PN_model.Delay=[PN_model.Delay,TrValue];
    PN_model.Rate=[PN_model.Rate,0];
elseif Type==21 %BPMN Component Task_Stochastic_Timed_Exp_SelfService
    PN_model.Delay=[PN_model.Delay,0];
    PN_model.Rate=[PN_model.Rate,TrValue];
elseif Type==22 %BPMN Component Task_Stochastic_Timed_Norm_SelfService
    PN_model.Rate=[PN_model.Rate,TrValue(1)];
    PN_model.Rate2(numel(PN_model.Rate))=TrValue(2);
    PN_model.Delay=[PN_model.Delay,abs(normrnd(TrValue(1),TrValue(2)))];
elseif Type==23 %BPMN Component Task_Stochastic_Timed_Unif_SelfService
    PN_model.Rate=[PN_model.Rate,TrValue(1)];
    PN_model.Rate2(numel(PN_model.Rate))=TrValue(2);
    PN_model.Delay=[PN_model.Delay,abs(unifrnd(TrValue(1),TrValue(2)))];
    
elseif Type==24  %BPMN Component Task_Timed_ParallelMultiServer 
    PN_model.Delay=[PN_model.Delay,TrValue];
    PN_model.Rate=[PN_model.Rate,0];
elseif Type==25 %BPMN Component Task_Stochastic_Timed_Exp_ParallelMultiServer
    PN_model.Delay=[PN_model.Delay,0];
    PN_model.Rate=[PN_model.Rate,TrValue];
elseif Type==26 %BPMN Component Task_Stochastic_Timed_Norm_ParallelMultiServer
    PN_model.Rate=[PN_model.Rate,TrValue(1)];
    PN_model.Rate2(numel(PN_model.Rate))=TrValue(2);
    PN_model.Delay=[PN_model.Delay,abs(normrnd(TrValue(1),TrValue(2)))];
elseif Type==27 %BPMN Component Task_Stochastic_Timed_Unif_ParallelMultiServer
    PN_model.Rate=[PN_model.Rate,TrValue(1)];
    PN_model.Rate2(numel(PN_model.Rate))=TrValue(2);
    PN_model.Delay=[PN_model.Delay,abs(unifrnd(TrValue(1),TrValue(2)))];
else
    errmsg=['Error:Transition Type ', num2str(Type), ' is unknown! (in transition ''', Name, ''')'];
    error(errmsg);
end

PN_model.Priority=[PN_model.Priority,Priority];
PN_model.ProbWeight=[PN_model.ProbWeight,Probability];

    
t.Delay=[];             
t.Rate=[];              
t.ProbWeight=[];        



PN_model.TknDly=[PN_model.TknDly,TknDly];
PN_model.PPre=[PN_model.PPre,{[]}];
PN_model.Pre_Weight=[PN_model.Pre_Weight,{[]}];
PN_model.InhPre_Weight=[PN_model.InhPre_Weight,{[]}];
PN_model.InhPPre=[PN_model.InhPPre,{[]}];
PN_model.PPost=[PN_model.PPost,{[]}];
PN_model.Post_Weight=[PN_model.Post_Weight,{[]}];
PN_model.address=[PN_model.address;0];
PN_model.Comment=[PN_model.Comment;{''}];
PN_model.SelfService=[PN_model.SelfService;0];