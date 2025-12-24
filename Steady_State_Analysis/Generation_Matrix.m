function Q=Generation_Matrix(TRMG)
Q=zeros(size(TRMG.A));           
Q(TRMG.D>0)=1 ./ TRMG.D(TRMG.D>0);  %Consider the inverse of delay as the average rate
Q(TRMG.A>0 & TRMG.D==0)=100000;     %A big rate for the case of delay=0
diameter=sum(Q,2);                  %the main diameter of generation matrix will be the inverse of sum of outgoing delay
for i=1:numel(diameter)             %assign diameter of generation matrix one by one
    if diameter(i)>0
        Q(i,i)=-diameter(i);
    else
        Q(i,i)=-100000;
    end
end