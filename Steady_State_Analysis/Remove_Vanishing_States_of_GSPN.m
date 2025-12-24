function RMG=Remove_Vanishing_States_of_GSPN(RMG,PN_model)
% Xi:Vanishing atates 
% Yj:input states of Vanishing atate Xi
% Zk:Output states of Vanishing atate Xi

TrTypeMat=zeros(size(RMG.A));
TrTypeMat(RMG.A>0)=PN_model.Tr_Type(RMG.A (RMG.A>0));   %Transition type matrix; 
X=find(sum(TrTypeMat==0 & RMG.A>0,2)>0);                %find all states with immediate outgoing transitions (vanishing states)


for i=1:numel(X)
    Y=find(RMG.A(:,X(i))>0);                              %find all input states of Vanishing atate Xi
    Z=find((RMG.A(X(i),:)>0) & (TrTypeMat(X(i),:)==0));   %find all output states of Vanishing atate Xi
    for j=1:numel(Y)
        for k=1:numel(Z)
            if Y(j)~=Z(k)
                RMG.R(Y(j),Z(k))=RMG.R(Y(j),Z(k))+RMG.R(Y(j),X(i))*RMG.R(X(i),Z(k));
                RMG.A(Y(j),Z(k))=RMG.A(Y(j),X(i));
            end
        end
    end
end
X=sort(X);

% for i=1:numel(X)
    RMG.R(X,:)=[];
    RMG.R(:,X)=[];
    RMG.A(X,:)=[];
    RMG.A(:,X)=[];
    RMG.RM(:,X)=[];
    RMG.VS=[];
% end