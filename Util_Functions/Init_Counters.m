function PN_model=Init_Counters(PN_model)
%initialize counters
notr=numel(PN_model.T);
PN_model.CountT=zeros(size(PN_model.Delay));
for Tr=1:notr
    if numel(PN_model.low_level_model(Tr).T)>0
        PN_model.low_level_model(Tr)=Init_Counters(PN_model.low_level_model(Tr));
    elseif (PN_model.Tr_Type(Tr)==1)			%timed
        PN_model.CountT(Tr)=PN_model.Delay(Tr);
    elseif (PN_model.Tr_Type(Tr)==2)			%stochastic
        PN_model.CountT(Tr)=PN_model.Delay(Tr); %PN_model.Delay(Tr) has already been initialized by 'exprnd(PN_model.Rate(Tr))' while newing a transition 
    elseif (PN_model.Tr_Type(Tr)==3)			%stochastic
        PN_model.CountT(Tr)=PN_model.Delay(Tr); %PN_model.Delay(Tr) has already been initialized by 'normrnd(PN_model.Rate(Tr),PN_model.Rate2(Tr))' while newing a transition 
    elseif (PN_model.Tr_Type(Tr)==4)			%stochastic
        PN_model.CountT(Tr)=PN_model.Delay(Tr); %PN_model.Delay(Tr) has already been initialized by 'unifrnd(PN_model.Rate(Tr),PN_model.Rate2(Tr))' while newing a transition 

%     elseif (PN_model.Tr_Type(Tr)==12)			%BPMN Component XOR Gateway
%         PN_model.CountT(Tr)=PN_model.Delay(Tr); %PN_model.Delay(Tr) has already been initialized by TrValue while newing a transition 

    elseif (PN_model.Tr_Type(Tr)==0)            %Immedeiate
        PN_model.CountT(Tr)=0;
    end
end
