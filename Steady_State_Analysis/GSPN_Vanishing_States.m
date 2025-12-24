function VS=GSPN_Vanishing_States(RMG,PN_model)

TrTypeMat=zeros(size(RMG.A));
TrTypeMat(RMG.A>0)=PN_model.Tr_Type(RMG.A (RMG.A>0));   %Transition type matrix; 
VS=find(sum(TrTypeMat==0 & RMG.A>0,2)>0);                %find all states with immediate outgoing transitions (vanishing states)
