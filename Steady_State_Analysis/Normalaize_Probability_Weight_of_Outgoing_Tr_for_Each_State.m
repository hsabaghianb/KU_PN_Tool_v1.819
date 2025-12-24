function RMG=Normalaize_Probability_Weight_of_Outgoing_Tr_for_Each_State(PN_model,RMG)  
%In mixed immadiate-stochastic model RMG.R is mixed of transition rate and transition probability weight 
    TrTypeMat=zeros(size(RMG.A));
    TrTypeMat(RMG.A>0)=PN_model.Tr_Type(RMG.A (RMG.A>0));   %Transition type matrix; 
    ImmTypeMask=(TrTypeMat==0) & (RMG.A>0);                %find all states with immediate outgoing transitions (vanishing states) 
    SumProb=sum(ImmTypeMask .* RMG.R,2);
    SumProb=SumProb+(SumProb==0);
    DivMat=repmat(SumProb,1,size(RMG.R,2));
    DivMat(ImmTypeMask==0)=1;
    RMG.R=RMG.R./(DivMat);
end 