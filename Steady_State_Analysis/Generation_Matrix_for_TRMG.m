function Q=Generation_Matrix_for_TRMG(TRMG,PN_model)
ProbMat=zeros(size(TRMG.A));
ProbMat(TRMG.A>0)=TRMG.Pr(TRMG.A>0);   %adjacency matrix with probability weight value; 
ProbMatSum=repmat(sum(ProbMat,2),1,size(ProbMat,2));        %branches in TRMG means simultanus firing which is randomly selected using probability weight
rate_Probability_factor=ProbMat;
rate_Probability_factor(ProbMat>0)=ProbMat(ProbMat>0) ./ ProbMatSum(ProbMat>0);     %the probability factors will be multiplied with the rate

Q=zeros(size(TRMG.A)); 
Q(TRMG.D>0)=1 ./ TRMG.D(TRMG.D>0);                          %Consider the inverse of delay as the average rate
Q=Q.*rate_Probability_factor;                               %the probability factors are multiplied with the rate here
Q(TRMG.A>0 & TRMG.D==0)=100000;                             %A big rate for the case of delay=0
diameter=sum(Q,2);                                          %the main diameter of generation matrix will be the inverse of sum of outgoing delay
for i=1:numel(diameter)                                     %assign diameter of generation matrix one by one
    if diameter(i)>0
        Q(i,i)=-diameter(i);
    else
        Q(i,i)=-100000;
    end
end