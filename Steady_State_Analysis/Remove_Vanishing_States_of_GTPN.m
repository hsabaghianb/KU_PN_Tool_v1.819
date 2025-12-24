function TRMG=Remove_Vanishing_States_of_GTPN(TRMG,PN_model)
% Xi:Vanishing atates 
% Yj:input states of Vanishing atate Xi
% Zk:Output states of Vanishing atate Xi

% TrTypeMat=zeros(size(TRMG.A));
% TrTypeMat(TRMG.A>0)=PN_model.Tr_Type(TRMG.A (TRMG.A>0));   %Transition type matrix; 
% X=find(sum((TrTypeMat==0 | (TrTypeMat==1 & TRMG.D==0)) & TRMG.A>0,2)>0);       %find all states with immediate or zero timed outgoing transitions (vanishing states)
X=GTPN_Vanishing_States(TRMG,PN_model);
for i=1:numel(X)
    Y=find(TRMG.A(:,X(i))>0);                              %find all input states of Vanishing atate Xi
    Z=find(TRMG.A(X(i),:)>0);                           %find all output states of Vanishing atate Xi
    for j=1:numel(Y)
        for k=1:numel(Z)
            TRMG.D(Y(j),Z(k))=TRMG.D(Y(j),X(i));
            TRMG.A(Y(j),Z(k))=TRMG.A(Y(j),X(i));
            TRMG.Pr(Y(j),Z(k))=TRMG.Pr(Y(j),Z(k))+TRMG.Pr(Y(j),X(i))*TRMG.Pr(X(i),Z(k));
        end
    end
end
X=sort(X);

% for i=1:numel(X)
    TRMG.D(X,:)=[];
    TRMG.D(:,X)=[];
    TRMG.A(X,:)=[];
    TRMG.A(:,X)=[];
    TRMG.Pr(X,:)=[];
    TRMG.Pr(:,X)=[];
    TRMG.RM(:,X)=[];
    TRMG.RMD(:,X)=[];
    TRMG.RMTD(:,X)=[];
    TRMG.VS=[];
% end