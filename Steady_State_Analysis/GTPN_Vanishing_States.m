function VS=GTPN_Vanishing_States(TRMG,PN_model)

TrTypeMat=zeros(size(TRMG.A));
TrTypeMat(TRMG.A>0)=PN_model.Tr_Type(TRMG.A (TRMG.A>0));   %Transition type matrix; 
ZeroTimeTr_logicMat=(TrTypeMat==0 | (TrTypeMat==1 & TRMG.D==0)) & TRMG.A>0;
% VS1_Logic=sum(ZeroTimeTr_logicMat,2)==1;
VS=find(sum(ZeroTimeTr_logicMat,2)>0);                                         %find all states with just 1 immediate or zero timed outgoing transitions (vanishing states)
                                                                                 %the states with more than 1 immediate or zero timed outgoing transitions could not be deleted
                                                                                 %unless all of it's next states are also vanishing
% VS_all_Logic=sum(ZeroTimeTr_logicMat,2)>0;                                 %find all states with more than 0 immediate or zero timed outgoing transitions                                                                            
% mask=repmat(VS_all_Logic,1,size(ZeroTimeTr_logicMat,2))';                  %remove all transitions connected to a next non-zero-delay transition 
% ZeroTimeTr_logicMat_2=ZeroTimeTr_logicMat.*mask;
% sum1=sum(ZeroTimeTr_logicMat,2);
% sum2=sum(ZeroTimeTr_logicMat_2,2);
% VS2_Logic= sum1==sum2 & sum1>0 & sum2>0; 
% VS=find(VS1_Logic | VS2_Logic);