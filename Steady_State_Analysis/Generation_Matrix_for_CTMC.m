function Q=Generation_Matrix_for_CTMC(RMG)
Q=RMG.R;           
diameter=sum(Q,2);                  %the main diameter of generation matrix will be the -sum of outgoing delay
for i=1:numel(diameter)             %assign diameter of generation matrix one by one
    if diameter(i)>0
        Q(i,i)=-diameter(i);
    end
end
